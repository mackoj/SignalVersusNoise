//
//  DeviceListModel.swift
//  TCA Debugger
//
//  Created by Jeffrey Macko on 04/11/2020.
//

import SwiftUI
import Combine
import ServerTransceiver
import ComposableArchitecture


class DeviceListModel: ObservableObject {
    
    @Published var groups: [ModelGroup] = []
    
    struct ModelGroup : Identifiable/*, Comparable*/ {
//        static func < (lhs: DeviceListModel.ModelGroup, rhs: DeviceListModel.ModelGroup) -> Bool {
//            return true
////            if let lhsRawValue = lhs.model?.clie,
////               let rhsRawValue = rhs.model?.rawValue {
////                return lhsRawValue < rhsRawValue
////            }
////            if let lhsName = lhs.device?.name,
////               let rhsName = rhs.device?.name {
////                return lhsName < rhsName
////            }
////            return (lhs.contents?.count ?? 0) < (rhs.contents?.count ?? 0)
//        }
        
        let id: UUID = UUID()
        let model: DeviceModel?
        var client: ServerTransceiver.Client?
        var contents: [ModelGroup]?
        
        init(branch: [ServerTransceiver.Client], model: DeviceModel) {
            self.model = model
            self.contents = branch.map { ModelGroup(leaf: $0) }
            self.client = nil
        }
        
        init(leaf: ServerTransceiver.Client) {
            self.model = nil
            self.contents = nil
            self.client = leaf
        }
    }
    
    init(_ clients :  IdentifiedArrayOf<ServerTransceiver.Client>) {
        var localGroups : [ModelGroup] = []
        let localGroupsOrganized : [DeviceModel : [ServerTransceiver.Client]] = clients.reduce(into: [DeviceModel : [ServerTransceiver.Client]]()) { (res, client) in
            let model = DeviceModel(rawValue: client.context?.device.model ?? "🤷🏾‍♂️") ?? .unknow("not possible")
            var groupContent = res[model] ?? []
            groupContent.append(client)
            res[model] = groupContent
        }
        
        for (key, value) in localGroupsOrganized {
            localGroups.append(.init(branch: value, model: key))
        }
//        localGroups.sort(by: >)
        self.groups = localGroups
    }
    
    func getDevice(modeGroupID: ModelGroup.ID?) -> ServerTransceiver.Client? {
        guard let id = modeGroupID else { return nil }
        
        for itm in groups {
            if itm.id == id {
                return itm.client
            }
        }
        return nil
    }
}

