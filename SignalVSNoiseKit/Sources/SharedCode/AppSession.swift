import Foundation
import UIKit
import CoreTelephony
import AnyCodable

public struct AppSession<State : Codable> : Codable, Identifiable, Equatable {
    public var id = UUID()
    var events: [Event<AnyCodable>] = []
    var date = Date()
    var appContext = AppContext()
    
    init(_ bundle: Bundle = .main, _ fileManager : FileManager = .default) {
        appContext = AppContext(bundle, fileManager)
    }
    
    public static func == (lhs: AppSession, rhs: AppSession) -> Bool {
        return lhs.id == rhs.id
    }
    
    mutating func addEvent(_ event : Event<AnyCodable>) {
        events.append(event)
        date = Date(timeIntervalSinceReferenceDate: event.timestamp)
    }
}


public struct AppContext: Codable, Equatable {
    public struct AppInfo: Codable, Equatable {
        public var bundleShortVersion: String
        public var bundleVersion: String
        public var bundleDevelopmentRegion: String
        public var bundleExecutable: String
        public var bundleName: String
        public var bundleIdentifier: String
    }
    
    public struct DeviceInfo: Codable, Equatable {
        public var model: String
        public var localizedModel: String
        public var name: String
        public var systemName: String
        public var systemVersion: String
        public var locale: String
        public var operators: [String]
        public var timezone: String
        public var freeDiskSpace: String
        public var totalDiskSpace: String
        public var usedDiskSpace: String
        public var networkType: String?
        public var batteryPercentage: Double
        public var screenWidth: Int
        public var screenHeight: Int
    }
    
    public var app : AppInfo
    public var device : DeviceInfo
    
    init(_ bundle: Bundle = .main, _ fileManager : FileManager = .default) {
        self.app = AppInfo(
            bundleShortVersion: bundle.object(from: "CFBundleShortVersionString"),
            bundleVersion: bundle.object(from: "CFBundleVersion"),
            bundleDevelopmentRegion: bundle.object(from: "CFBundleDevelopmentRegion"),
            bundleExecutable: bundle.object(from: "CFBundleExecutable"),
            bundleName: bundle.object(from: "CFBundleName"),
            bundleIdentifier: bundle.object(from: "CFBundleIdentifier")
        )
        
        let networkInfo = CTTelephonyNetworkInfo()
        let operators = networkInfo.serviceSubscriberCellularProviders?.reduce(into: [String](), { (res, info) in
            if let operatorName = info.value.carrierName {
                res.append(operatorName)
            }
        }) ?? []
        
        let diskStatus = DiskStatus(fileManager)
        self.device = DeviceInfo (
            model: UIDevice.current.model,
            localizedModel: UIDevice.current.localizedModel,
            name: UIDevice.current.name,
            systemName: UIDevice.current.systemName,
            systemVersion: UIDevice.current.systemVersion,
            locale: Locale.current.identifier,
            operators: operators,
            timezone: TimeZone.current.identifier,
            freeDiskSpace: diskStatus.freeDiskSpace,
            totalDiskSpace: diskStatus.totalDiskSpace,
            usedDiskSpace: diskStatus.usedDiskSpace,
            networkType: networkInfo.currentRadioAccessTechnology, // serviceCurrentRadioAccessTechnology ??
            batteryPercentage: Double(UIDevice.current.batteryLevel),
            screenWidth: Int(UIScreen.main.bounds.width),
            screenHeight: Int(UIScreen.main.bounds.height)
        )
    }
}

extension Bundle {
    func object(from key : String) -> String {
        (self.object(forInfoDictionaryKey: key) as? String) ?? ""
    }
}
