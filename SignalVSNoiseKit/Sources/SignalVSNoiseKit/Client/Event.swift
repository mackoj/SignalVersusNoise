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
