import Foundation
import ComposableArchitecture
import ServerTCADebugger

struct FeedState: Equatable {
    var id: String { client.peer.id }
    let client : SVNServerTransceiver.Client
    var rows: IdentifiedArrayOf<Feed>
//    var selection: Identified<Feed.ID, FeedState>?
}

enum FeedAction {
    case row(index: UUID, action: FeedRowAction)
}

enum FeedRowAction {
    case tapped
}
