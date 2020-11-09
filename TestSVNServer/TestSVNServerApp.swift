import SwiftUI
import SignalVSNoiseKit
import ComposableArchitecture


struct AppState : Equatable {
  var peers : [String : SVNServerTransceiver.Client] = [:]
}

enum AppAction {
  case deviceListView(DeviceListViewAction)
}
//
//let appReducer = Reducer<AppState, AppAction, AppEnvironnement>.empty
//{
//  state, action, env in
//  switch action {
//
//  }
//
//  return .none
//}.combine

//struct AppEnvironnement {
//    var svn : SVNServerTransceiver
//
//    init() {
//      svn = SVNServerTransceiver(
//        "Boos Bitch 🔥",
//        nil,
//        NotificationCenter.default,
//        Bundle.main,
//        FileManager.default
//      )
//    }
//}

@main
struct TestSVNServerApp: App {
//  var store : Store<AppState, AppAction>
  
  init() {
//    store = Store<AppState, AppAction>(
//      initialState: AppState(),
//      reducer: appReducer,
//      environment: AppEnvironnement()
//    )
  }
  
  var body: some Scene {
    WindowGroup {
        DeviceListView()
//      ContentView(store: store)
    }
  }
}
