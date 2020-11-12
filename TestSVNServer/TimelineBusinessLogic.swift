import Foundation
import ComposableArchitecture

struct TimelineState: Equatable {
    var id: UUID { feed.id }
    let feed: Feed
}

enum TimelineAction {
    case item(index: UUID, action: EventAction)
}

enum EventAction {
    case tapped
}
