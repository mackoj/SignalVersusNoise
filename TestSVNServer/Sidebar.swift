import SwiftUI
import ComposableArchitecture
import ServerTransceiver

struct Sidebar: View {
    let store : Store<SidebarState, SidebarAction>
    @State private var selection: UUID? = nil

    public init(store: Store<SidebarState, SidebarAction>) {
        self.store = store
        ViewStore(self.store).send(.onInit)
    }
    
    func model(_ viewStore : ViewStore<SidebarState, SidebarAction>) -> DeviceListModel {
        DeviceListModel(viewStore.clients)
    }
    
    func selectedPeerName(_ viewStore : ViewStore<SidebarState, SidebarAction>) -> String {
        model(viewStore).getDevice(modeGroupID: selection)?.peer.name ?? "n/a"
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
                        .foregroundColor(selection == nil ? Color.secondary : Color.green)
                        .font(.title2)
                    List(model(viewStore).groups, children: \.contents, selection: $selection) { item in
                        ClientItem(item: item)
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
