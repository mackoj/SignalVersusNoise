import Foundation
import ComposableArchitecture
import ServerTransceiver
import UIKit

struct AppState: Equatable {
    var feed: FeedState?
    var timeline: TimelineState?
    var sidebar: SidebarState = SidebarState(serverState: .preping)
}

enum AppAction {
    case sidebar(SidebarAction)
    case feed(FeedAction)
    case timeline(TimelineAction)
}



let appReducer = Reducer<AppState, AppAction, AppEnvironnement>.combine([
    sidebarReducer.pullback(
      state: \AppState.sidebar,
      action: /AppAction.sidebar,
      environment: { $0 }
    ),

    Reducer<AppState, AppAction, AppEnvironnement> {
        state, action, env in
        switch action {
        case .sidebar(.reloadDevices):
            return .none

        case let .feed(.row(rowIndex, rowAction)):
            return .none

        case let .timeline(.item(itemIndex, itemAction)):
            return .none
            
        case .sidebar(.onInit):
            return .none

        case let .sidebar(.updateClients(clients)):
            if let client = clients.first?.value {
                let arrayOfFeed = IdentifiedArrayOf<Feed>(client.sessions.map { Feed(id: $0.key, live: nil, session: $0.value) })
                print("🦄 \(arrayOfFeed)")
                state.feed = FeedState(client: client, rows: arrayOfFeed)
            }
            return .none

        case .sidebar(.client(index: let index, action: let action)):
            return .none

        case let .sidebar(.clientSelection(selectionID)):
            return .none
        }
    }
])

struct AppEnvironnement {
    var serverTransceiver : ServerTransceiver
}
