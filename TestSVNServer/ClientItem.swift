import SwiftUI
import ComposableArchitecture
import ServerTransceiver

struct ClientItem: View {
    
    //    let store: Store<DeviceListModel.ModelGroup, ClientItemAction>
    let item: DeviceListModel.ModelGroup
    
    func computedText(_ item : DeviceListModel.ModelGroup) -> String {
        item.model?.rawValue ?? "\(item.client!.peer.name)"
    }
    
    func computedSystemImage(_ item : DeviceListModel.ModelGroup) -> String {
        if let model = item.client?.context?.device.model,
           let deviceModel = DeviceModel(rawValue: model) {
            return deviceModel.systemImage
        }
        return item.model?.systemImage ?? "xmark.octagon.fill"
    }
    
    func computedForegroundColor(_ item : DeviceListModel.ModelGroup) -> Color {
         Color.accentColor
    }
    
    
    var body: some View {
        Group {
            if item.model != nil { // Section
                Label(
                    computedText(item),
                    systemImage: computedSystemImage(item)
                )
            } else { // Client
                HStack {
                    Image(systemName: computedSystemImage(item))
                        .foregroundColor(computedForegroundColor(item))
                    Text(computedText(item))
                    if (item.client?.hasAskForAttention ?? false) == true {
                        Image(systemName: "hand.wave")
                    }
                }.tag(item.id)
                .background((item.client?.hasAskForAttention ?? false) ? Color.yellow : Color.clear)
            }
        }
    }
}

