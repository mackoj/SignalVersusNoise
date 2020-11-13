import AnyCodable
import Combine
import Foundation
import MultipeerKit
import ServerTransceiver
import SharedCode

extension ServerTransceiver {
  internal static var live:
    (
      _ peerName: String,
      _ defaultQueue: OperationQueue?,
      _ center: NotificationCenter,
      _ bundle: Bundle,
      _ fManager: FileManager,
      _ debugMode: Bool
    ) -> Self = { peerName, queue, notificationCenter, bundle, fileManager, debugMode in
      let subject = PassthroughSubject<Clients, Never>()

      var loggedClient: Clients = [:] {
        didSet {
          subject.send(loggedClient)
        }
      }

      var configuration = MultipeerConfiguration.default
      configuration.peerName = peerName
      configuration.security.encryptionPreference = .required
      configuration.serviceType = "svn-tca"

      // MARK: Start
      let transceiver = MultipeerTransceiver(configuration: configuration)

      // MARK: - HandleClient
      transceiver.peerRemoved = { peer in
        _ = loggedClient.removeValue(forKey: peer.id)
      }

      transceiver.peerAdded = { peer in
        transceiver.send(ServerMultipeerTransceiverAsk.connect, to: [peer])
      }

      transceiver.receive(DebuggerType.self) { (dtype, peer) in
        var obj = loggedClient[peer.id] ?? Client(peer: peer)
        obj.dType = dtype
        loggedClient[peer.id] = obj
      }

      transceiver.availablePeersDidChange = { peers in
        let connectedIDs = peers.filter { $0.isConnected }
        let identifiedPeers = loggedClient.map { $0.value.peer }
        var peerToConnect: [Peer] = []
        for aConnectedPeer in connectedIDs {
          if identifiedPeers.contains(where: { $0.id == aConnectedPeer.id }) { continue }
          peerToConnect.append(aConnectedPeer)
        }
        if !peerToConnect.isEmpty {
          let invitedPeers = peerToConnect.map(\.name).joined(separator: ", ")
          print("[\(invitedPeers)] has been invited to joined the party 🚀")
          transceiver.send(ServerMultipeerTransceiverAsk.connect, to: peerToConnect)
        }
      }

      transceiver.receive(Event<AnyCodable>.self) { (event: Event<AnyCodable>, peer) in
        var obj = loggedClient[peer.id] ?? Client(peer: peer)
        obj.events[event.timestamp] = event
        loggedClient[peer.id] = obj
      }

      transceiver.receive(AppSession<AnyCodable>.self) {
        (appSession: AppSession<AnyCodable>, peer) in

        var obj = loggedClient[peer.id] ?? Client(peer: peer)
        obj.sessions[appSession.id.uuidString] = appSession
        loggedClient[peer.id] = obj
      }

      transceiver.receive([String].self) { (sessions: [String], peer) in
        var obj = loggedClient[peer.id] ?? Client(peer: peer)
        obj.sessionFiles = sessions
        loggedClient[peer.id] = obj
      }

      transceiver.receive(AppContext.self) { (context: AppContext, peer) in
        var obj = loggedClient[peer.id] ?? Client(peer: peer)
        obj.context = context
        loggedClient[peer.id] = obj
        transceiver.send(ServerMultipeerTransceiverAsk.live, to: [peer])
      }

      transceiver.receive(ClientMultipeerTransceiverAsk.self) {
        (ask: ClientMultipeerTransceiverAsk, peer) in
        switch ask {
        case .register:
          transceiver.send(ServerMultipeerTransceiverAsk.connect, to: [peer])
          transceiver.send(ServerMultipeerTransceiverAsk.live, to: [peer])
        case .askForAttention:
          var obj = loggedClient[peer.id] ?? Client(peer: peer)
          obj.hasAskForAttention = true
          loggedClient[peer.id] = obj
        }
      }

      return ServerTransceiver(
        serverName: peerName,
        clientPublisher: subject.eraseToAnyPublisher(),
        sendAction: { (client, action) in
          switch action {

          }
        },
        start: {
          transceiver.resume()
          transceiver.broadcast(DebuggerType.server)
        },
        stop: { transceiver.stop() }
      )
    }
}
