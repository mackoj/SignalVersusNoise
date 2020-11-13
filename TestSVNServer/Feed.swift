import Foundation
import SharedCode
import AnyCodable

struct Feed: Equatable, Identifiable {
    static func == (lhs: Feed, rhs: Feed) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    var live: FeedSubscriber?
    var session: AppSession<AnyCodable>? 
}
