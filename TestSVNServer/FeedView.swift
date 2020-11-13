import SwiftUI
import ServerTransceiver
import Combine
import AnyCodable
import SharedCode
import ComposableArchitecture

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
