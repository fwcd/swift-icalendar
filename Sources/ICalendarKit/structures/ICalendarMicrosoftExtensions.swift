import VComponentKit

/// Specifies the BUSY status of an appointment.
///
/// See https://docs.microsoft.com/en-us/openspecs/exchange_server_protocols/ms-oxcical/cd68eae7-ed65-4dd3-8ea7-ad585c76c736
public enum ICalendarMicrosoftStatus: VPropertyEncodable {
    case free
    case tentative
    case busy
    case oof
    
    public var vEncoded: String {
        switch self {
            case .free:
                return "FREE"
            case .tentative:
                return "TENTATIVE"
            case .busy:
                return "BUSY"
            case .oof:
                return "OOF"
        }
    }
}

/// Specifies the importance of an appointment.
///
/// See https://docs.microsoft.com/en-us/openspecs/exchange_server_protocols/ms-oxcical/38b4e7a9-8dec-488a-a901-85cfe71171d8
public enum ICalendarMicrosoftImportance: VPropertyEncodable {
    case one
    case two
    case three
    
    public var vEncoded: String {
        switch self {
            case .one:
                return "0"
            case .two:
                return "1"
            case .three:
                return "2"
        }
    }
}
