import SwiftUI
import ComposableArchitecture

struct DeviceListViewState {
  
}

enum DeviceListViewAction {
  case reload
  case selectDevice(String)
}

let deviceListViewReducer = Reducer<DeviceListViewState, DeviceListViewAction, AppEnvironnement> {
  state, action, env in
  switch action {
  case .reload:
    break
  case let .selectDevice(id):
    break
  }
  return .none
}

struct DeviceListView: View {
  @StateObject private var model = DeviceListModel()
  @State private var selection: DeviceListModel.ModelGroup.ID? = nil
  
  var body: some View {
      VStack(spacing: 20) {
        Text("Selected Item = \(model.getDevice(modeGroupID: selection)?.name ?? "n/a")")
          .foregroundColor(selection == nil ? Color.secondary : Color.green)
          .font(.title2)

        List(model.groups, children: \.contents, selection: $selection) { item in
          DeviceListItemView(item: item)
        }
        .listStyle(SidebarListStyle())
        .frame(width: 300)
        
        // SavedSessions
      }
  }
}
