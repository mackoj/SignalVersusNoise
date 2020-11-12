//
//  ContentView.swift
//  TestSVNServer
//
//  Created by Jeffrey Macko on 08/11/2020.
//

import SwiftUI
import ComposableArchitecture

struct SidebarState: Equatable {
    enum ServerState: String, Equatable {
        case preping
        case ready
    }
    var serverState : ServerState = .preping
}

enum SidebarAction {
    case reloadDevices
}

struct Sidebar: View {
    let store : Store<SidebarState, SidebarAction>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            switch viewStore.serverState {
            case .preping:
                Text("Warming up")
            case .ready:
                VStack {
                    DeviceListView()
                }
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
