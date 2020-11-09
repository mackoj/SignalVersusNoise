import SwiftUI
import ComposableArchitecture
import SignalVSNoiseKit

struct DeviceListItemView: View {
  let item: DeviceListModel.ModelGroup
  
  var computedText : String {
    item.model?.rawValue ?? "\(item.device!.client.peer.name)"
  }
  var computedSystemImage : String {
    item.model?.systemImage ?? "xmark.octagon.fill"
  }
  
  var computedForegroundColor: Color {
    /*item.device?.color ??*/ Color.accentColor
  }
  
  var body: some View {
    Group {
      if item.model != nil { // Section
        Label(computedText, systemImage: computedSystemImage)
          .tag(item.id)
      } else { // Device
        HStack {
          Image(systemName: computedSystemImage).foregroundColor(computedForegroundColor)
          Text(computedText)
        }.tag(item.id)
      }
    }
  }
}

//struct DeviceListItemView_Leaf_Previews: PreviewProvider {
//  static var previews: some View {
//    DeviceListItemView(item:
//                        DeviceListModel.ModelGroup(
//                          leaf: Device(
//                            name: "Tel 1",
//                            model: .iPhone,
//                            app: "com.pikachu.fr",
//                            color: .blue,
//                            message: "Blablabla"
//                          )
//                        )
//    ).previewLayout(.sizeThatFits)
//  }
//}
//
//struct DeviceListItemView_Branch_Empty_Previews: PreviewProvider {
//  static var previews: some View {
//    DeviceListItemView(item: DeviceListModel.ModelGroup(branch: [], model: .iPhone)).previewLayout(.sizeThatFits)
//  }
//}
//
//struct DeviceListItemView_Branch_Previews: PreviewProvider {
//  static var previews: some View {
//    DeviceListItemView(item: DeviceListModel.ModelGroup(branch: [
//      Device(
//        name: "Tel 1",
//        model: .iPhone,
//        app: "com.pikachu.fr",
//        color: .blue,
//        message: "Blablabla"
//      )
//    ], model: .iPhone)).previewLayout(.sizeThatFits)
//  }
//}
