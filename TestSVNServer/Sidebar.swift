//
//  ContentView.swift
//  TestSVNServer
//
//  Created by Jeffrey Macko on 08/11/2020.
//

import SwiftUI
import ComposableArchitecture

struct Sidebar: View {
    let store : Store<SidebarState, SidebarAction>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            switch viewStore.serverState {
            case .preping:
                VStack {
                    Image(systemName: "bonjour")
                    Text("Warming up")
                }
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
