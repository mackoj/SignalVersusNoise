import SwiftUI
import ServerTransceiver
import ServerTransceiverLive
import ComposableArchitecture

@main
struct TestSVNServerApp: App {
    var store: Store<AppState, AppAction>

    init() {
        store = Store<AppState, AppAction>(
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnvironnement.init(
                serverTransceiver:
                    ServerTransceiver.prod(
                        UIDevice.current.name,
                        nil,
                        NotificationCenter.default,
                        Bundle.main,
                        FileManager.default
                    )
            )
        )
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
    }
}

