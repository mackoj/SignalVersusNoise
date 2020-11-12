//
//  SidebarBusinessLogic.swift
//  TestSVNServer
//
//  Created by Jeffrey Macko on 12/11/2020.
//

import Foundation
import ComposableArchitecture

struct SidebarState: Equatable {
    enum ServerState: String, Equatable {
        case preping
        case ready
    }
    var serverState : ServerState = .preping
}

enum SidebarAction {
    case reloadDevices
}
