import XCTest
import Foundation
@testable import ICalendarKit

final class ICalendarTests: XCTestCase {
    static var allTests = [
        ("testICalendarWithEvent", testICalendarWithEvent),
        ("testICalendarWithEventAndTimeZone", testICalendarWithEventAndTimeZone)
    ]

    /// A few dates for testing 
    private var dates: [(date: Date, encoded: String, encodedWithoutTime: String)]!
    private var dateFormatter: DateFormatter = DateFormatter()
    
    override func setUp() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)!
        dateFormatter.locale = Locale.init(identifier: "UTC")
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        
        dates = (0..<20).map { (i: Int) -> (date: Date, encoded: String, encodedWithoutTime: String) in
            let year = 2021
            let month = 3
            let day = 1
            let hour = i
            let minute = 0
            let second = 0

            let date = calendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: second))!
            let encoded = String(format: "%04d%02d%02dT%02d%02d%02dZ", year, month, day, hour, minute, second)
            let encodedWithoutTime = String(format: "%04d%02d%02d", year, month, day)

            return (date: date, encoded: encoded, encodedWithoutTime: encodedWithoutTime)
        }
    }
    
    func testICalendarWithEvent() throws {
        var cal = ICalendar()
        let description = "Test"
        let uid = "test"

        cal.events.append(ICalendarEvent(
            dtstamp: dates[0].date,
            uid: uid,
            created: dates[1].date,
            description: description,
            dtstart: .dateTime(dates[2].date),
            lastModified: dates[3].date,
            dtend: .dateOnly(dates[4].date)
        ))

        XCTAssertEqual(cal.vEncoded, [
            "BEGIN:VCALENDAR",
            "VERSION:2.0",
            "PRODID:-//swift-calendar//icalendarkit//EN",
            "CALSCALE:GREGORIAN",
            "BEGIN:VEVENT",
            "DTSTAMP:\(dates[0].encoded)",
            "UID:\(uid)",
            "CREATED:\(dates[1].encoded)",
            "DESCRIPTION:\(description)",
            "DTSTART:\(dates[2].encoded)",
            "LAST-MODIFIED:\(dates[3].encoded)",
            "DTEND;VALUE=DATE:\(dates[4].encodedWithoutTime)",
            "END:VEVENT",
            "END:VCALENDAR"
        ].map { "\($0)\r\n" }.joined())
    }

    func testICalendarWithEventAndTimeZone() throws {
        var cal = ICalendar()
        let description = "Test"
        let uid = "test"
        let dstart = Date()
        let dstartStr = dateFormatter.string(from: dstart)

        cal.events.append(ICalendarEvent(
            dtstamp: dates[0].date,
            uid: uid,
            created: dates[1].date,
            description: description,
            dtstart: .dateTime(dates[2].date),
            lastModified: dates[3].date,
            dtend: .dateOnly(dates[4].date),
            timeZone: ICalendarTimeZone(
                tzid: "America/Mexico_City",
                daylight: DaylightComponent(
                    tzOffsetFrom: "-0600",
                    rrule: .init(
                        frequency: .yearly,
                        byDay: [
                            .first(.saturday)
                        ],
                        byDayOfMonth: [4]
                    ),
                    dstart: dstart,
                    tzName: "CDT",
                    tzOffsetTo: "-0500"
                ),
                standard: StandardComponent(
                    tzOffsetFrom: "-0500",
                    rrule: .init(
                        frequency: .yearly,
                        byDay: [
                            .first(.saturday)
                        ],
                        byDayOfMonth: [4]
                    ),
                    dstart: dstart,
                    tzName: "CDT",
                    tzOffsetTo: "-0600"
                )
            )
        ))
        
        let generatedCalendar: String = cal.vEncoded
        let manualCalendar: String = [
            "BEGIN:VCALENDAR",
            "VERSION:2.0",
            "PRODID:-//swift-calendar//icalendarkit//EN",
            "CALSCALE:GREGORIAN",
            "BEGIN:VEVENT",
            "DTSTAMP:\(dates[0].encoded)",
            "UID:\(uid)",
            "CREATED:\(dates[1].encoded)",
            "DESCRIPTION:\(description)",
            "DTSTART:\(dates[2].encoded)",
            "LAST-MODIFIED:\(dates[3].encoded)",
            "DTEND;VALUE=DATE:\(dates[4].encodedWithoutTime)",
            "BEGIN:VTIMEZONE",
            "TZID:America/Mexico_City",
            "BEGIN:DAYLIGHT",
            "TZOFFSETFROM:-0600",
            "RRULE:FREQ=YEARLY;BYDAY=1SA;BYMONTHDAY=4",
            "DTSTART:\(dstartStr)",
            "TZNAME:CDT",
            "TZOFFSETTO:-0500",
            "END:DAYLIGHT",
            "BEGIN:STANDARD",
            "TZOFFSETFROM:-0500",
            "RRULE:FREQ=YEARLY;BYDAY=1SA;BYMONTHDAY=4",
            "DTSTART:\(dstartStr)",
            "TZNAME:CDT",
            "TZOFFSETTO:-0600",
            "END:STANDARD",
            "END:VTIMEZONE",
            "END:VEVENT",
            "END:VCALENDAR"
        ].map { "\($0)\r\n" }.joined()

        XCTAssertEqual(generatedCalendar, manualCalendar)
    }
}
