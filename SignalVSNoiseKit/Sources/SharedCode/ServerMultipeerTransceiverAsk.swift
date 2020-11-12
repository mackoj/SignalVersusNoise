import Foundation

public enum DebuggerType: String, RawRepresentable, Codable {
  case server
  case client
  case unknown
}

public enum ServerMultipeerTransceiverAsk: Codable {
  case appContext
  case session(String)
  case allSessions
  case disconnect
  case live
  case connect

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    if let key = container.allKeys.first {
      switch key {

      case .appContext:
        self = .appContext

      case .allSessions:
        self = .allSessions

      case .disconnect:
        self = .disconnect

      case .connect:
        self = .connect

      case .live:
        self = .live

      case .session:
        let content = try container.decode(
          String.self,
          forKey: .session
        )
        self = .session(content)

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
    case .appContext:
      try container.encode(true, forKey: .appContext)

    case .disconnect:
      try container.encode(true, forKey: .disconnect)

    case .connect:
      try container.encode(true, forKey: .connect)

    case .live:
      try container.encode(true, forKey: .live)

    case .allSessions:
      try container.encode(true, forKey: .allSessions)

    case let .session(content):
      var nestedContainer = container.nestedUnkeyedContainer(forKey: .session)
      try nestedContainer.encode(content)

    }
  }

  enum CodingKeys: CodingKey {
    case appContext
    case session
    case allSessions
    case disconnect
    case live
    case connect
  }
}
