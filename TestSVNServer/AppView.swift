import Foundation
import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store : Store<AppState, AppAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                Sidebar(store: self.store.scope(state: \.sidebar, action: AppAction.sidebar))
                if viewStore.feed == nil && viewStore.timeline == nil {
                    VStack {
                        Image(systemName: "trash")
                        Text("Nothing")
                    }
                } else {
                    IfLetStore(
                        self.store.scope(state: \.feed, action: AppAction.feed),
                        then: FeedView.init(store:),
                        else: Text("No Feed")
                    )
                    IfLetStore(
                        self.store.scope(state: \.timeline, action: AppAction.timeline),
                        then: TimelineView.init(store:),
                        else: Text("No Timeline")
                    )
                }
            }
        }
    }
}
