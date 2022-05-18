import Foundation
import SharedCode
import AnyCodable

struct Feed: Equatable, Identifiable, CustomStringConvertible {
  static func == (lhs: Feed, rhs: Feed) -> Bool {
    lhs.id == rhs.id
  }
  
  let id: String
  var live: FeedSubscriber?
  var session: AppSession<AnyCodable>?
  
  var description: String {
    """
id: \(id)
session: \(session?.description)
"""
  }
}
