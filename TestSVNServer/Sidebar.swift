import SwiftUI
import ComposableArchitecture
import ServerTransceiver

struct ClientList: View {
    var model : DeviceListModel

    init(_ clients : IdentifiedArrayOf<ServerTransceiver.Client>) {
        self.model = DeviceListModel(clients)
    }

    var body: some View {
        List(model.groups, children: \.contents) { item in
            ClientItem(item: item)
        }
        .listStyle(SidebarListStyle())
    }
}

struct Sidebar: View {

    let store : Store<SidebarState, SidebarAction>

    public init(store: Store<SidebarState, SidebarAction>) {
        self.store = store
        ViewStore(self.store).send(.onInit)
    }
    
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
                    ClientList(viewStore.clients)
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
