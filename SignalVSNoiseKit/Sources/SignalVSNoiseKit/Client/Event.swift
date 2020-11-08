import Foundation

public struct Event<State : Codable> : Codable, Identifiable, Equatable {
  public var id : UUID = UUID()
  var timestamp: TimeInterval = Date.timeIntervalSinceReferenceDate
  let source: Source<State>
  
  init(_ source : Source<State>) {
    self.source = source
  }
  
  public static func == (lhs: Event, rhs: Event) -> Bool {
      return lhs.id == rhs.id
  }
}

public enum Source<State : Codable>: Codable {
  // AppLifeCycle
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
  
  // TCALifeCycle
  public enum TCALifeCycle: Codable {
    case sendAction(String) // whenever a action is send
    case performAction(String, State) // whenever a action is performed
    case withViewStore(State) // whenever the view is computed
    case stateChange(State) // origin ??
    case swiftUIBodyUpdate(String, State) // View
    
    enum CodingKeys: CodingKey {
      case performAction
      case sendAction
      case withViewStore
      case swiftUIBodyUpdate
      case stateChange
    }

    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      if let key = container.allKeys.first {
        switch key {
        case .performAction:
          var nestedContainer = try container.nestedUnkeyedContainer(forKey: .performAction)
          let actionName = try nestedContainer.decode(String.self)
          let state = try nestedContainer.decode(State.self)
          self = .performAction(actionName, state)

        case .sendAction:
          var nestedContainer = try container.nestedUnkeyedContainer(forKey: .sendAction)
          let actionName = try nestedContainer.decode(String.self)
          self = .sendAction(actionName)
          
        case .withViewStore:
          var nestedContainer = try container.nestedUnkeyedContainer(forKey: .withViewStore)
          let state = try nestedContainer.decode(State.self)
          self = .withViewStore(state)
          
        case .swiftUIBodyUpdate:
          var nestedContainer = try container.nestedUnkeyedContainer(forKey: .swiftUIBodyUpdate)
          let actionName = try nestedContainer.decode(String.self)
          let state = try nestedContainer.decode(State.self)
          self = .swiftUIBodyUpdate(actionName, state)

        case .stateChange:
          var nestedContainer = try container.nestedUnkeyedContainer(forKey: .stateChange)
          let state = try nestedContainer.decode(State.self)
          self = .stateChange(state)
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
      case let .performAction(actionName, state):
        var nestedContainer = container.nestedUnkeyedContainer(forKey: .performAction)
        try nestedContainer.encode(actionName)
        try nestedContainer.encode(state)
        
      case let .sendAction(actionName):
        var nestedContainer = container.nestedUnkeyedContainer(forKey: .sendAction)
        try nestedContainer.encode(actionName)

      case let .withViewStore(state):
        var nestedContainer = container.nestedUnkeyedContainer(forKey: .withViewStore)
        try nestedContainer.encode(state)

      case let .swiftUIBodyUpdate(viewName, state):
        var nestedContainer = container.nestedUnkeyedContainer(forKey: .swiftUIBodyUpdate)
        try nestedContainer.encode(viewName)
        try nestedContainer.encode(state)

      case let .stateChange(state):
        var nestedContainer = container.nestedUnkeyedContainer(forKey: .stateChange)
        try nestedContainer.encode(state)

      }
    }
  }
  
  case appLifeCycle(AppLifeCycle)
  case tcaLifeCycle(TCALifeCycle)
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    if let key = container.allKeys.first {
      switch key {
      case .appLifeCycle:
        let content = try container.decode(
          AppLifeCycle.self,
          forKey: .appLifeCycle
        )
        self = .appLifeCycle(content)

      case .tcaLifeCycle:
        let content = try container.decode(
          TCALifeCycle.self,
          forKey: .tcaLifeCycle
        )
        self = .tcaLifeCycle(content)

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
    case let .appLifeCycle(content):
      var nestedContainer = container.nestedUnkeyedContainer(forKey: .appLifeCycle)
      try nestedContainer.encode(content)

    case let .tcaLifeCycle(content):
      var nestedContainer = container.nestedUnkeyedContainer(forKey: .tcaLifeCycle)
      try nestedContainer.encode(content)

    }
  }

  enum CodingKeys: CodingKey {
    case appLifeCycle
    case tcaLifeCycle
  }
}
