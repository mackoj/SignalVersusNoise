import Foundation
import MultipeerKit
import AnyCodable

public class SVNServerTransceiver {
  var queue : OperationQueue?
  var notificationCenter : NotificationCenter
  var transceiver : MultipeerTransceiver
  var fileManager : FileManager
  var peers : [String : Client] = [:]
  
  public struct Client: Equatable {
    let peer : Peer
    var context : AppContext?
    var sessionFiles : [String] = []
    var sessions : [String : AppSession<AnyCodable>] = [:]
  }
  
  public init(_ peerName : String, _ defaultQueue : OperationQueue? = nil, _ center : NotificationCenter = NotificationCenter.default, _ bundle: Bundle = .main, _ fManager : FileManager = .default) {
    var configuration = MultipeerConfiguration.default
    configuration.peerName = peerName
    configuration.serviceType = "SVN_DEBUG"
    notificationCenter = center
    queue = defaultQueue
    fileManager = fManager
    transceiver = MultipeerTransceiver(configuration: configuration)
    handleClients()
    transceiver.broadcast(ServerMultipeerTransceiverAsk.connect)
  }
  
  deinit {
    transceiver.send(ServerMultipeerTransceiverAsk.disconnect, to: transceiver.availablePeers)
  }

  func handleClients() {
    transceiver.receive(AppSession<AnyCodable>.self) { [weak self] (appSession : AppSession<AnyCodable>, peer) in
      print(#function)
      guard let self = self else { return }
      var obj = self.peers[peer.id]
      obj?.sessions[appSession.id.uuidString] = appSession
      self.peers[peer.id] = obj
    }
    
    transceiver.receive([String].self) { [weak self] (sessions : [String], peer) in
      print(#function)
      guard let self = self else { return }
      var obj = self.peers[peer.id]
      obj?.sessionFiles = sessions
      self.peers[peer.id] = obj
    }
    
    transceiver.receive(AppContext.self) { [weak self] (context : AppContext, peer) in
      print(#function)
      guard let self = self else { return }
      var obj = self.peers[peer.id]
      obj?.context = context
      self.peers[peer.id] = obj
    }
    
    transceiver.receive(ClientMultipeerTransceiverAsk.self) { (ask : ClientMultipeerTransceiverAsk, peer) in
      print(#function)
      switch ask {
      case .register:
        print("Welcome to \(peer.name) 🚀")
        self.transceiver.send(ServerMultipeerTransceiverAsk.appContext, to: [peer])
        self.transceiver.send(ServerMultipeerTransceiverAsk.live, to: [peer])
      }
    }
  }
}
