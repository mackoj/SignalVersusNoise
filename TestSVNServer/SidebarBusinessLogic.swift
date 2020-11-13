//
//  SidebarBusinessLogic.swift
//  TestSVNServer
//
//  Created by Jeffrey Macko on 12/11/2020.
//

import Foundation
import ComposableArchitecture
import ServerTransceiver

extension ServerTransceiver.Client: Identifiable {
    public var id: String { peer.id }
}

struct SidebarState: Equatable {
    enum ServerState: String, Equatable {
        case preping
        case ready
    }
    var serverState: ServerState = .preping
    var clients: IdentifiedArrayOf<ServerTransceiver.Client> = []
}

enum ClientItemAction {
    case tapped
}

enum SidebarAction {
    case onInit
    case reloadDevices
    case updateClients(ServerTransceiver.Clients)
    case client(index: String, action: ClientItemAction)
}

let sidebarReducer = Reducer<SidebarState, SidebarAction, AppEnvironnement> {
    (state, action, env) -> Effect<SidebarAction, Never> in
    
    struct SidebarReducerID : Hashable {}
    
    switch action {
    case .onInit:
        env.serverTransceiver.start()
        return env
            .serverTransceiver
            .clientPublisher
            .eraseToEffect()
            .map(SidebarAction.updateClients)
            .cancellable(id: SidebarReducerID())
        
    case .reloadDevices:
        break

    case let .client(index: clientIndex, action: clientAction):
        break

    case let .updateClients(clients):
        state.serverState = clients.isEmpty ? .preping : .ready
        state.clients = IdentifiedArrayOf<ServerTransceiver.Client>.init(clients.map { $0.value })
    }
    return .none
}
