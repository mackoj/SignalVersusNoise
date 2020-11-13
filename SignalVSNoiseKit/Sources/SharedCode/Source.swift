import Foundation

public enum Source<State: Codable>: Codable {
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
      try container.encode(content, forKey: .appLifeCycle)

    case let .tcaLifeCycle(content):
      try container.encode(content, forKey: .tcaLifeCycle)

    }
  }

  enum CodingKeys: CodingKey {
    case appLifeCycle
    case tcaLifeCycle
  }
}
