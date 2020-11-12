import Foundation
import SharedCode
import AnyCodable

struct Feed: Equatable, Identifiable {
    static func == (lhs: Feed, rhs: Feed) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: UUID
    var live: FeedSubscriber?
    var sessions: [AppSession<AnyCodable>] = []
}
