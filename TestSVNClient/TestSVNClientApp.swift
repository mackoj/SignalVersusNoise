import SwiftUI
import SignalVSNoiseKit
import ComposableArchitecture
import AnyCodable

struct AppState : Codable {
  var counter : Int
}

enum AppAction {
  case inc
  case dec
}

struct AppEnvironnement {
  var svn : SVNClientTransceiver
  
  init() {
    svn = SVNClientTransceiver(
      AppState.self,
      "Peer Name 😘",
      nil,
      NotificationCenter.default,
      Bundle.main,
      FileManager.default
    )
  }
}

let appReducer = Reducer<AppState, AppAction, AppEnvironnement> {
  state, action, env in
  switch action {
  case .inc:
    state.counter = state.counter + 1
    
  case .dec:
    state.counter = state.counter - 1

  }
  
  return .none
}

@main
struct TestSVNClientApp: App {
  var store : Store<AppState, AppAction>
  
  init() {
    let env = AppEnvironnement()
    store = Store<AppState, AppAction>(
      initialState: AppState(counter: 0),
      reducer: appReducer,
      environment: AppEnvironnement()
    )
    
    store.sendAction = { env.svn.recordEvent(.tcaLifeCycle(.sendAction($0))) }
    store.withViewStore = { env.svn.recordEvent(.tcaLifeCycle(.withViewStore(AnyCodable($0)))) }
    store.stateChange = { env.svn.recordEvent(.tcaLifeCycle(.stateChange(AnyCodable($0)))) }
    store.swiftUIBodyUpdate = { env.svn.recordEvent(.tcaLifeCycle(.swiftUIBodyUpdate($0, AnyCodable($1)))) }    
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView(store: store)
    }
  }
}
