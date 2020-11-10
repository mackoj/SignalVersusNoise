import Foundation

extension Source {
  public enum TCALifeCycle: Codable {
    case sendAction(String)  // whenever a action is send
    case performAction(String, State)  // whenever a action is performed
    case withViewStore(State)  // whenever the view is computed
    case stateChange(State)  // origin ??
    case swiftUIBodyUpdate(String, State)  // View

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

}
