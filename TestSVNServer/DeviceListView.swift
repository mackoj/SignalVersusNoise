import SwiftUI
import ComposableArchitecture
import ServerTCADebugger

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
    @ObservedObject var svn = SVNServerTransceiver(
        "Boos Bitch 🔥",
        nil,
        NotificationCenter.default,
        Bundle.main,
        FileManager.default
    )
    /// on update - regenerate devicelistmodel

//    var devices : [Device] {
//        self.svn.peers.map { (line) in
//            let client = line.value
//            let device = Device(
//                name: <#T##String#>,
//                model: <#T##Device.Model#>,
//                app: <#T##String#>,
//                color: <#T##Color#>,
//                message: T##String?
//            )
//        }
//    }
    
    var peers : [SVNServerTransceiver.Client] {
        svn.peers.map { $0.value }
    }
    
    var body: some View {
        VStack {
            Text("Server")
            ForEach(peers, id: \.peer.id) { node in
                Text(node.peer.name)
                Text(node.context?.app.bundleIdentifier ?? "bundleIdentifier")
            }
        }
//        VStack(spacing: 20) {
//            Text("Selected Item = \(model.getDevice(modeGroupID: selection)?.name ?? "n/a")")
//                .foregroundColor(selection == nil ? Color.secondary : Color.green)
//                .font(.title2)
            
//            List(model.groups, children: \.contents, selection: $selection) { item in
//                DeviceListItemView(item: item)
//            }
//            .listStyle(SidebarListStyle())
//            .frame(width: 300)
            
            // SavedSessions
//        }
    }
}
