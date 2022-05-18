import SwiftUI
import ClientTCADebugger
import ComposableArchitecture
import AnyCodable

struct AppState : Codable {
  var counter : Int
}

enum AppAction {
  case inc
  case dec
  case allSessions
}

struct AppEnvironnement {
  var svn: SVNClientTransceiver
  
  init() {
    svn = SVNClientTransceiver(
      AppState.self,
      nil,
      UserDefaults.standard,
      NotificationCenter.default,
      Bundle.main,
      FileManager.default
    )
  }
}

var appReducer = Reducer<AppState, AppAction, AppEnvironnement> {
  state, action, env in
  switch action {
    case .allSessions:
      env.svn.sendAllSessions()
      
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
      environment: env
    )
    appReducer.performedAction = { env.svn.recordEvent(.tcaLifeCycle(.afterSendAction($0, AnyCodable($1)))) }
    store.sendAction = { env.svn.recordEvent(.tcaLifeCycle(.beforeSendAction($0))) }
    store.withViewStore = { env.svn.recordEvent(.tcaLifeCycle(.withViewStore(AnyCodable($0)))) }
    store.stateChange = { env.svn.recordEvent(.tcaLifeCycle(.stateChange($0, AnyCodable($1)))) }
    store.swiftUIBodyUpdate = { env.svn.recordEvent(.tcaLifeCycle(.swiftUIBodyUpdate($0, AnyCodable($1)))) }
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView(store: store)
    }
  }
}
