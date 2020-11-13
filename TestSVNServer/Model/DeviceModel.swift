import Foundation

enum DeviceModel : RawRepresentable, Hashable {
    var rawValue: String {
        switch self {
        case let .iPhone(content): return content
        case let .iPad(content): return content
        case let .iPod(content): return content
        case let .mac(content): return content
        case let .watch(content): return content
        case let .tv(content): return content
        case let .simulator(content): return content
        case let .unknow(content): return content
        }
    }
    
    case iPhone(String)
    case iPad(String)
    case iPod(String)
    case mac(String)
    case watch(String)
    case tv(String)
    case simulator(String)
    case unknow(String)
    
    init?(rawValue: String?) {
        guard let rawValue = rawValue else {
            self = .unknow("preping...")
            return
        }
        self = DeviceModel.knowSelf(rawValue: rawValue)
    }
    
    init?(rawValue: String) {
        self = DeviceModel.knowSelf(rawValue: rawValue)
    }
    
    static func knowSelf(rawValue: String) -> Self {
        if rawValue.contains("AppleTV") {
            return .tv(rawValue)
        }
        else if rawValue.contains("iPad") {
            return .iPad(rawValue)
        }
        else if rawValue.contains("iPhone") {
            return .iPhone(rawValue)
        }
        else if rawValue.contains("iPod") {
            return .iPod(rawValue)
        }
        else if rawValue.contains("Watch") {
            return .watch(rawValue)
        }
        else if rawValue.contains("i386") || rawValue.contains("x86_64") {
            return .simulator(rawValue)
        }
        else {
            return .unknow(rawValue)
        }
    }
    var systemImage : String {
        switch self {
        case .iPhone:
            return "iphone"
        case .iPad:
            return "ipad"
        case .iPod:
            return "ipodtouch"
        case .mac:
            return "desktopcomputer"
        case .watch:
            return "applewatch"
        case .tv:
            return "appletv"
        case .unknow:
            return "display"
        case .simulator:
            return "display"
        }
    }
}
