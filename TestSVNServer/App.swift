import SwiftUI
import ServerTCADebugger
import ComposableArchitecture

@main
struct TestSVNServerApp: App {
    var store : Store<AppState, AppAction>
    
    init() {
        store = Store<AppState, AppAction>(
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnvironnement()
        )
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
    }
}

struct AppView: View {
    let store : Store<AppState, AppAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                Sidebar(store: self.store.scope(state: \.sidebarState, action: AppAction.sidebar))
                IfLetStore(
                    self.store.scope(state: \.feedState, action: AppAction.feed),
                    then: FeedView.init(store:),
                    else: Text("No Feed")
                )
                IfLetStore(
                    self.store.scope(state: \.timelineState, action: AppAction.timeline),
                    then: TimelineView.init(store:),
                    else: Text("No Timeline")
                )
            }
        }
    }
}
