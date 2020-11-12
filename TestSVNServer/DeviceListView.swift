import SwiftUI
import ComposableArchitecture
import ServerTCADebugger
import SharedCode
import MultipeerKit

struct DeviceListViewState {
    
}

enum DeviceListViewAction {
    case reload
    case selectDevice(String)
}
//
//let deviceListViewReducer = Reducer<DeviceListViewState, DeviceListViewAction, AppEnvironnement> {
//  state, action, env in
//  switch action {
//  case .reload:
//    break
//  case let .selectDevice(id):
//    break
//  }
//  return .none
//}

struct DeviceListView: View {
    @State private var model = DeviceListModel()
    @State private var selection: DeviceListModel.ModelGroup.ID? = nil
    @ObservedObject var svn =  SVNServerTransceiver(
        UIDevice.current.name,
        nil,
        NotificationCenter.default,
        Bundle.main,
        FileManager.default
    )
    
    var peers : [SVNServerTransceiver.Client] {
        self.svn.loggedClient.map { $0.value }
    }

    var body: some View {
        Group {
            VStack {
                Text("Server")
                ForEach(peers, id: \.peer.id) { node in
                    Text("- " + node.peer.name)
                }
            }
            VStack(spacing: 20) {
                Text("Selected Item = \(model.getDevice(modeGroupID: selection)?.peer.name ?? "n/a")")
                    .foregroundColor(selection == nil ? Color.secondary : Color.green)
                    .font(.title2)
                
                List(model.groups, children: \.contents, selection: $selection) { item in
                    DeviceListItemView(item: item)
                }
                .listStyle(SidebarListStyle())
                .frame(width: 300)
                
    //             SavedSessions
            }
        }
    }
}



struct DeviceListView_Empty_Previews: PreviewProvider {
  static var previews: some View {
    DeviceListView().previewLayout(.sizeThatFits)
  }
}

struct DeviceListView_NotEmpty_Previews: PreviewProvider {
  static var previews: some View {
    DeviceListView().previewLayout(.sizeThatFits)
  }
}
