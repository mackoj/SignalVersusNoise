import SwiftUI
import ComposableArchitecture
import ServerTransceiver

struct Sidebar: View {
    let store : Store<SidebarState, SidebarAction>
    
    public init(store: Store<SidebarState, SidebarAction>) {
        self.store = store
        ViewStore(self.store).send(.onInit)
    }
    
    func model(_ viewStore : ViewStore<SidebarState, SidebarAction>) -> DeviceListModel {
        DeviceListModel(viewStore.clients)
    }
    
    func selectedPeerName(_ viewStore : ViewStore<SidebarState, SidebarAction>) -> String {
        return model(viewStore)
            .getDevice(modeGroupID: viewStore.selectedClient)?
            .peer
            .name ?? "n/a"
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
                    Text("Selected Client = \(selectedPeerName(viewStore))")
                        .foregroundColor(viewStore.selectedClient == nil ? Color.secondary : Color.green)
                        .font(.title2)
                    List(
                        model(viewStore).groups,
                        children: \.contents,
                        selection: viewStore.binding(
                            get: \.selectedClient,
                            send: { SidebarAction.clientSelection($0) }
                        )
                    ) { item in
                        ClientItem(item: item).tag(item.id)
                    }.listStyle(SidebarListStyle())
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
