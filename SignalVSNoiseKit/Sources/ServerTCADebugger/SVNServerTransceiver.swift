import Foundation
import MultipeerKit
import AnyCodable
import Combine
import SharedCode

public class SVNServerTransceiver : ObservableObject {
    var queue : OperationQueue?
    var notificationCenter : NotificationCenter
    var transceiver : MultipeerTransceiver
    var fileManager : FileManager
    @Published public var peers : [String : Client] = [:] {
        didSet {
            print(peers)
        }
    }
    
    public struct Client: Equatable {
        public let peer : Peer
        public var context : AppContext?
        public var sessionFiles : [String] = []
        public var sessions : [String : AppSession<AnyCodable>] = [:]
    }
    
    public init(_ peerName : String, _ defaultQueue : OperationQueue? = nil, _ center : NotificationCenter = NotificationCenter.default, _ bundle: Bundle = .main, _ fManager : FileManager = .default) {
        var configuration = MultipeerConfiguration.default
        configuration.peerName = "server"
//        configuration.serviceType = "Debugger"
        notificationCenter = center
        queue = defaultQueue
        fileManager = fManager
        transceiver = MultipeerTransceiver(configuration: configuration)
        transceiver.resume()
        handleClients()
        transceiver.broadcast(ServerMultipeerTransceiverAsk.connect)
    }
    
    deinit {
        transceiver.send(
            ServerMultipeerTransceiverAsk.disconnect,
            to: transceiver.availablePeers
        )
    }
    
    func handleClients() {
        transceiver.receive(AppSession<AnyCodable>.self) { [weak self] (appSession : AppSession<AnyCodable>, peer) in
            print(#line)
            guard let self = self else { return }
            var obj = self.peers[peer.id]
            obj?.sessions[appSession.id.uuidString] = appSession
            self.peers[peer.id] = obj
        }
        
        transceiver.receive([String].self) { [weak self] (sessions : [String], peer) in
            print(#line)
            guard let self = self else { return }
            var obj = self.peers[peer.id]
            obj?.sessionFiles = sessions
            self.peers[peer.id] = obj
        }
        
        transceiver.receive(AppContext.self) { [weak self] (context : AppContext, peer) in
            print(#line)
            guard let self = self else { return }
            var obj = self.peers[peer.id]
            obj?.context = context
            self.peers[peer.id] = obj
        }
        
        transceiver.receive(ClientMultipeerTransceiverAsk.self) { (ask : ClientMultipeerTransceiverAsk, peer) in
            print(#line)
            switch ask {
            case .register:
                print("Welcome to \(peer.name) 🚀")
                self.transceiver.send(ServerMultipeerTransceiverAsk.appContext, to: [peer])
                self.transceiver.send(ServerMultipeerTransceiverAsk.live, to: [peer])
            }
        }
    }
}
