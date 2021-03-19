import Foundation
import VComponentKit

/// A collection of calendaring and scheduling information.
///
/// See https://tools.ietf.org/html/rfc5545#section-3.4
public struct ICalendar: VComponent {
    public let component = "VCALENDAR"

    /// The identifier corresponding to the highest version number
    /// or the minimum and maximum range of the iCalendar specification
    /// that is required in order to interpret the iCalendar object.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.7.4
    public let version = "2.0"

    /// The identifier for the product that created the iCalendar
    /// object.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.7.3
    public var prodid: ICalendarProductIdentifier

    /// The calendar scale for the calendar information specified
    /// in this iCalendar object.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.7.1
    public var calscale: String?

    /// The iCalendar object method associated with the calendar
    /// object.
    ///
    /// See https://tools.ietf.org/html/rfc5545#section-3.7.2
    public var method: String?
    
    /// Specifies the name of the calendar
    ///
    /// See https://docs.microsoft.com/en-us/openspecs/exchange_server_protocols/ms-oxcical/1da58449-b97e-46bd-b018-a1ce576f3e6d
    public var xWRCalName: String?
    
    /// Specifies the description of the calendar.
    ///
    /// See https://docs.microsoft.com/en-us/openspecs/exchange_server_protocols/ms-oxcical/9194db93-6de2-41b3-bebe-fc76a11e31e9
    public var xWRCalDesc: String?
    
    /// Specifies a globally unique identifier for the calendar
    ///
    /// See https://docs.microsoft.com/en-us/openspecs/exchange_server_protocols/ms-oxcical/3ef9f606-0d63-4e56-a86d-73617afa7383
    public var xWRRecalID: UUID?
    
    /// Specifies a suggested iCalendar file
    /// download frequency for clients and
    /// servers with sync capabilities.
    ///
    /// See https://docs.microsoft.com/en-us/openspecs/exchange_server_protocols/ms-oxcical/1fc7b244-ecd1-4d28-ac0c-2bb4df855a1f#Appendix_A_Target_32
    public var xPublishedTTL: ICalendarDuration?

    public var events: [ICalendarEvent]
    public var toDos: [ICalendarToDo]
    public var freeBusies: [ICalendarFreeBusy]
    public var journals: [ICalendarJournal]
    public var timeZones: [ICalendarTimeZone]
    public var alarms: [ICalendarAlarm]

    public var children: [VComponent] {
        [events, toDos, journals, freeBusies, timeZones, alarms].flatMap { $0 as! [VComponent] }
    }

    public var properties: [VContentLine?] {
        [
            .line("VERSION", version),
            .line("PRODID", prodid),
            .line("CALSCALE", calscale),
            .line("METHOD", method),
            .line("X-WR-CALNAME", xWRCalName),
            .line("X-WR-CALDESC", xWRCalDesc),
            .line("X-WR-RELCALID", xWRRecalID),
            .line("X-PUBLISHED-TTL", xPublishedTTL)
        ]
    }

    public init(
        prodid: ICalendarProductIdentifier = ICalendarProductIdentifier(),
        calscale: String? = "GREGORIAN",
        method: String? = nil,
        events: [ICalendarEvent] = [],
        toDos: [ICalendarToDo] = [],
        freeBusies: [ICalendarFreeBusy] = [],
        journals: [ICalendarJournal] = [],
        timeZones: [ICalendarTimeZone] = [],
        alarms: [ICalendarAlarm] = [],
        xWRCalName: String? = nil,
        xWRCalDesc: String? = nil,
        xWRRecalID: UUID? = nil,
        xPublishedTTL: ICalendarDuration? = nil
    ) {
        self.prodid = prodid
        self.calscale = calscale
        self.method = method
        self.events = events
        self.toDos = toDos
        self.freeBusies = freeBusies
        self.journals = journals
        self.timeZones = timeZones
        self.alarms = alarms
        self.xWRCalName = xWRCalName
        self.xWRCalDesc = xWRCalDesc
        self.xWRRecalID = xWRRecalID
        self.xPublishedTTL = xPublishedTTL
    }
}
