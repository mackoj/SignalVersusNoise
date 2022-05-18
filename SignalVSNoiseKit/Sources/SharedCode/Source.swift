import Foundation

public enum Source<State: Codable>: Codable {
  case appLifeCycle(AppLifeCycle)
  case tcaLifeCycle(TCALifeCycle)
}
