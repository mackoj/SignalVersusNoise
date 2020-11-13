import SwiftUI
import ServerTransceiver
import Combine
import AnyCodable
import SharedCode
import ComposableArchitecture

struct FeedView: View {
    let store : Store<FeedState, FeedAction>
    let dateFormater = DateFormatter()
    init(store : Store<FeedState, FeedAction>) {
        self.store = store
    }
    
    
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ForEach(viewStore.rows, id: \.id) { feed in
                Text(feed.id)
//                if let sessions = feed.session {
//                    ForEach(sessions.events) { event in
//                        Text(dateFormater.string(from: Date(timeIntervalSinceReferenceDate: event.timestamp)))
//                    }
//                }
            }
        }
    }
}
