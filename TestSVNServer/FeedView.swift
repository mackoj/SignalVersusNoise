import SwiftUI
import ComposableArchitecture
import ServerTCADebugger
import Combine
import AnyCodable
import SharedCode

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

struct FeedView: View {
    let store : Store<FeedState, FeedAction>
    
    init(store : Store<FeedState, FeedAction>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ForEach(viewStore.rows, id: \.id) { feed in
                Text("Bobo")
//                TimelineView(store:
//                              Store(
//                                initialState: feed,
//                                reducer: timelineReducer,
//                                environment:
//                              )
//                )
            }
//            ForEachStore(viewStore.rows) { localStore -> View in
//                TimelineView(store: localStore)
//            }
//            List(self.model.fruits, selection: $selection) { fruit in
//                FruitRow(fruit: fruit).tag(fruit.id)
//            }
        }
    }
}
