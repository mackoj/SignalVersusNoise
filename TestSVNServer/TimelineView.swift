import SwiftUI
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

struct TimelineView: View {
    let store : Store<TimelineState, TimelineAction>
    var body: some View {
//        WithViewStore(self.store) { viewStore in
            Text("Timeline")
//        }
    }
}

//struct TimelineView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimelineView()
//    }
//}
