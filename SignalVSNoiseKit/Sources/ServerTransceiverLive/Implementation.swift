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
        if let deleted = loggedClient.removeValue(forKey: peer.id) {
          print("👻")
          dump(deleted)
        }
        loggedClient[peer.id] = Client(peer: peer)
      }

      transceiver.availablePeersDidChange = { peers in
        let connectedIDs = peers.filter { $0.isConnected }.map { $0.id }
        if connectedIDs.isEmpty { return }

        if loggedClient.isEmpty { return }
        var peerToConnect: [Peer] = loggedClient.lazy
          .filter { connectedIDs.contains($0.value.peer.id) && $0.value.isLogged == false }
          .map { $0.value.peer }
        if peerToConnect.isEmpty { return }

        let invitedPeers = peerToConnect.map(\.name).joined(separator: ", ")
        print("[\(invitedPeers)] has been invited to joined the party 🚀")
        transceiver.send(ServerMultipeerTransceiverAsk.connect, to: peerToConnect)
        transceiver.send(ServerMultipeerTransceiverAsk.allSessions, to: peerToConnect)
      }

      // MARK: ServerMultipeerTransceiverAsk.connect
      transceiver.receive(DebuggerType.self) { (dtype, peer) in
        var obj = loggedClient[peer.id] ?? Client(peer: peer)
        obj.dType = dtype
        obj.isLogged = true
        loggedClient[peer.id] = obj
      }

      // MARK: ServerMultipeerTransceiverAsk.appContext
      transceiver.receive(AppContext.self) { (context: AppContext, peer) in
        var obj = loggedClient[peer.id] ?? Client(peer: peer)
        obj.context = context
        obj.isLogged = true
        loggedClient[peer.id] = obj
        transceiver.send(ServerMultipeerTransceiverAsk.live, to: [peer])
      }

      // MARK: ServerMultipeerTransceiverAsk.live
      transceiver.receive(Event<AnyCodable>.self) { (event: Event<AnyCodable>, peer) in
        var obj = loggedClient[peer.id] ?? Client(peer: peer)
        obj.events[event.timestamp] = event
        loggedClient[peer.id] = obj
      }

      // MARK: ServerMultipeerTransceiverAsk.session
      transceiver.receive(AppSession<AnyCodable>.self) {
        (appSession: AppSession<AnyCodable>, peer) in

        var obj = loggedClient[peer.id] ?? Client(peer: peer)
        obj.sessions[appSession.id.uuidString] = appSession
        loggedClient[peer.id] = obj
      }

      // MARK: ServerMultipeerTransceiverAsk.allSessions
      transceiver.receive([String: AppSession<AnyCodable>].self) {
        (sessions: [String: AppSession<AnyCodable>], peer) in

        var obj = loggedClient[peer.id] ?? Client(peer: peer)
        obj.sessions = sessions
        loggedClient[peer.id] = obj
      }

      // MARK: ServerMultipeerTransceiverAsk.disconnect
      // do noting on server side

      // MARK: ClientMultipeerTransceiverAsk.register
      // MARK: ClientMultipeerTransceiverAsk.askForAttention
      transceiver.receive(ClientMultipeerTransceiverAsk.self) {
        (ask: ClientMultipeerTransceiverAsk, peer) in
        switch ask {
        case .register:
          transceiver.send(ServerMultipeerTransceiverAsk.connect, to: [peer])
          transceiver.send(ServerMultipeerTransceiverAsk.live, to: [peer])
          transceiver.send(ServerMultipeerTransceiverAsk.allSessions, to: [peer])
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
