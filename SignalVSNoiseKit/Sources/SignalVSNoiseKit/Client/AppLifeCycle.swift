import Foundation

extension Source {
  public enum AppLifeCycle: Codable {
    case didEnterBackground
    case willEnterForeground
    case didFinishLaunching
    case didBecomeActive
    case willResignActive
    case didReceiveMemoryWarning
    case willTerminate
    case significantTimeChange
    case backgroundRefreshStatusDidChange
    case protectedDataWillBecomeUnavailable
    case protectedDataDidBecomeAvailable
    case userDidTakeScreenshot
    case crash(CrashModel)
    
    enum CodingKeys: CodingKey {
      case didEnterBackground
      case willEnterForeground
      case didFinishLaunching
      case didBecomeActive
      case willResignActive
      case didReceiveMemoryWarning
      case willTerminate
      case significantTimeChange
      case backgroundRefreshStatusDidChange
      case protectedDataWillBecomeUnavailable
      case protectedDataDidBecomeAvailable
      case userDidTakeScreenshot
      case crash
    }

    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      if let key = container.allKeys.first {
        switch key {
        case .didEnterBackground:
          self = .didEnterBackground
        case .willEnterForeground:
          self = .willEnterForeground
        case .didFinishLaunching:
          self = .didFinishLaunching
        case .didBecomeActive:
          self = .didBecomeActive
        case .willResignActive:
          self = .willResignActive
        case .didReceiveMemoryWarning:
          self = .didReceiveMemoryWarning
        case .willTerminate:
          self = .willTerminate
        case .significantTimeChange:
          self = .significantTimeChange
        case .backgroundRefreshStatusDidChange:
          self = .backgroundRefreshStatusDidChange
        case .protectedDataWillBecomeUnavailable:
          self = .protectedDataWillBecomeUnavailable
        case .protectedDataDidBecomeAvailable:
          self = .protectedDataDidBecomeAvailable
        case .userDidTakeScreenshot:
          self = .userDidTakeScreenshot
        case .crash:
          let crashData = try container.decode(
            CrashModel.self,
            forKey: .crash
          )
          self = .crash(crashData)
        }
      } else {
        throw DecodingError.dataCorrupted(
          DecodingError.Context(
            codingPath: container.codingPath,
            debugDescription: "Unabled to decode enum."
          )
        )
      }
    }
    
    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      switch self {
      case .didEnterBackground:
        try container.encode(true, forKey: .didEnterBackground)
      case .willEnterForeground:
        try container.encode(true, forKey: .willEnterForeground)
      case .didFinishLaunching:
        try container.encode(true, forKey: .didFinishLaunching)
      case .didBecomeActive:
        try container.encode(true, forKey: .didBecomeActive)
      case .willResignActive:
        try container.encode(true, forKey: .willResignActive)
      case .didReceiveMemoryWarning:
        try container.encode(true, forKey: .didReceiveMemoryWarning)
      case .willTerminate:
        try container.encode(true, forKey: .willTerminate)
      case .significantTimeChange:
        try container.encode(true, forKey: .significantTimeChange)
      case .backgroundRefreshStatusDidChange:
        try container.encode(true, forKey: .backgroundRefreshStatusDidChange)
      case .protectedDataWillBecomeUnavailable:
        try container.encode(true, forKey: .protectedDataWillBecomeUnavailable)
      case .protectedDataDidBecomeAvailable:
        try container.encode(true, forKey: .protectedDataDidBecomeAvailable)
      case .userDidTakeScreenshot:
        try container.encode(true, forKey: .userDidTakeScreenshot)
      case let .crash(crashContent):
        try container.encode(crashContent, forKey: .crash)
      }
    }
  }

}
