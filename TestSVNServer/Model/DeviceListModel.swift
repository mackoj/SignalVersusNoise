//
//  DeviceListModel.swift
//  TCA Debugger
//
//  Created by Jeffrey Macko on 04/11/2020.
//

import SwiftUI
import Combine

class DeviceListModel: ObservableObject {
  
  @Published var groups: [ModelGroup] = []
  
  struct ModelGroup : Identifiable, Comparable {
    static func < (lhs: DeviceListModel.ModelGroup, rhs: DeviceListModel.ModelGroup) -> Bool {
      if let lhsRawValue = lhs.model?.rawValue,
         let rhsRawValue = rhs.model?.rawValue {
        return lhsRawValue < rhsRawValue
      }
      if let lhsName = lhs.device?.name,
         let rhsName = rhs.device?.name {
        return lhsName < rhsName
      }
      return (lhs.contents?.count ?? 0) < (rhs.contents?.count ?? 0)
    }
    
    let id: UUID = UUID()
    let model: Device.Model?
    var device: Device?
    var contents: [ModelGroup]?
    
    init(branch: [Device], model: Device.Model) {
      self.model = model
      self.contents = branch.map { ModelGroup(leaf: $0) }
      self.device = nil
    }
    
    init(leaf: Device) {
      self.model = nil
      self.contents = nil
      self.device = leaf
    }
  }

  init(_ devices : [Device] = .mock) {
    var localGroups : [ModelGroup] = []
    let localGroupsOrganized : [Device.Model : [Device]] = devices.reduce(into: [Device.Model : [Device]]()) { (res, device) in
      var groupContent = res[device.model]
      if groupContent == nil {
        groupContent = []
      }
      groupContent?.append(device)
      res[device.model] = groupContent
    }
    
    for (key, value) in localGroupsOrganized {
      localGroups.append(.init(branch: value, model: key))
    }
    localGroups.sort(by: >)
    self.groups = localGroups
//    print(localGroups)
  }
  
    
  func getDevice(modeGroupID: ModelGroup.ID?) -> Device? {
    guard let id = modeGroupID else { return nil }
    
    for itm in groups {
      if itm.id == id {
        return itm.device
      }
    }
    return nil
  }
}

