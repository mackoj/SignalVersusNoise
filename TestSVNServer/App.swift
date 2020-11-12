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

