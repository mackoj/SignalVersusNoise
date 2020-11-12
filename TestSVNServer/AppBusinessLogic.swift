import Foundation
import ComposableArchitecture
import ServerTCADebugger
import UIKit

struct AppState: Equatable {
    var feedState: FeedState?
    var timelineState: TimelineState?
    var sidebarState: SidebarState = SidebarState(serverState: .preping)
}

enum AppAction {
    case sidebar(SidebarAction)
    case feed(FeedAction)
    case timeline(TimelineAction)
}

let appReducer = Reducer<AppState, AppAction, AppEnvironnement> {
    state, action, env in
    switch action {
    case .sidebar(.reloadDevices):
        return .none
    case let .feed(.row(rowIndex, rowAction)):
        return .none
    case let .timeline(.item(itemIndex, itemAction)):
        return .none
    }
}

struct AppEnvironnement {
    var serverTransceiver : SVNServerTransceiver
//    var clientTransceiver : SVNClientTransceiver
    
    init() {
        serverTransceiver = SVNServerTransceiver(
            UIDevice.current.name,
            nil,
            NotificationCenter.default,
            Bundle.main,
            FileManager.default
        )
    }
}
