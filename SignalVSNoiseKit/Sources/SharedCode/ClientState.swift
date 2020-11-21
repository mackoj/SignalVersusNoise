import Foundation
import MultipeerKit
import AnyCodable

public struct ClientIdentity : Equatable {
    public let peer: Peer
    public var dType: DebuggerType = .unknown
}

public struct ClientData : Equatable {
    public var context: AppContext?
    public var sessionFiles: [String] = []
    public var sessions: [String: AppSession<AnyCodable>] = [:]
    public var events: [TimeInterval: Event<AnyCodable>] = [:]
}

public struct Client: Equatable {
    public var identity: ClientIdentity
    public var data = ClientData()
    public var state : ClientOnServerSideState = .initialState
    
    public init(peer: Peer) {
        self.identity = ClientIdentity(peer: peer)
    }
}

public enum Action {
    case appContext
    case liveEvent
    case session(String)
    case allSessions
    case disconnect
    case noop
}


public enum ClientOnServerSideState : StateType {
    case limbo
    case visible
    case ready
    case disconnected
    
    public enum Effect {
        case peerAppear(Peer)
        case receivedAppContext(AppContext)
        case askForAttention
        case receivedEvent(Event<AnyCodable>)
        case receivedAllSession([String: AppSession<AnyCodable>])
        case receivedASession
        case peerDidDisappear
    }
    
    static let initialState = ClientOnServerSideState.limbo
    
    mutating func handleEvent(event: Effect) -> Action {
        switch (self, event) {
        
        case (.limbo, .peerAppear):
            self = .visible
            return .appContext
            
        case (.visible, .receivedAppContext):
            self = .ready
            
        case (.ready, .receivedAllSession): break
        case (.ready, .receivedASession): break
        case (.ready, .receivedEvent): break
            
        case (_, .peerDidDisappear):
            self = .disconnected
            
        default: break
        }
        return .noop
    }
    
}
