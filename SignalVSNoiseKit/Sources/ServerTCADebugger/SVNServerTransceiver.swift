import AnyCodable
import Combine
import Foundation
import MultipeerKit
import SharedCode

public class SVNServerTransceiver: ObservableObject {
  var queue: OperationQueue?
  var notificationCenter: NotificationCenter
  var transceiver: MultipeerTransceiver
  var fileManager: FileManager
  @Published public var loggedClient: [String: Client] = [:]

  public struct Client: Equatable {
    public let peer: Peer
    public var context: AppContext?
    public var sessionFiles: [String] = []
    public var sessions: [String: AppSession<AnyCodable>] = [:]
    public var events: [TimeInterval: Event<AnyCodable>] = [:]

    public init(
      peer: Peer,
      context: AppContext? = nil,
      sessionFiles: [String] = [],
      sessions: [String: AppSession<AnyCodable>] = [:]
    ) {
      self.peer = peer
      self.context = context
      self.sessionFiles = sessionFiles
      self.sessions = sessions
    }
  }

  public init(
    _ peerName: String,
    _ defaultQueue: OperationQueue? = nil,
    _ center: NotificationCenter = NotificationCenter.default,
    _ bundle: Bundle = .main,
    _ fManager: FileManager = .default
  ) {
    var configuration = MultipeerConfiguration.default
    configuration.peerName = peerName
    configuration.security.encryptionPreference = .required
    configuration.serviceType = "svn-tca"
    notificationCenter = center
    queue = defaultQueue
    fileManager = fManager
    transceiver = MultipeerTransceiver(configuration: configuration)
    transceiver.resume()
    handleClients()
  }

  deinit {
    transceiver.send(
      ServerMultipeerTransceiverAsk.disconnect,
      to: transceiver.availablePeers
    )
  }

  func handleClients() {
    transceiver.peerAdded = { [weak self] peer in
      self?.transceiver.send(ServerMultipeerTransceiverAsk.connect, to: [peer])
    }
    transceiver.availablePeersDidChange = { [weak self] peers in
      let connectedIDs = peers.filter { $0.isConnected }
      let identifiedPeers = self?.loggedClient.map { $0.value.peer } ?? []
      var peerToConnect: [Peer] = []
      for aConnectedPeer in connectedIDs {
        if identifiedPeers.contains(where: { $0.id == aConnectedPeer.id }) { continue }
        peerToConnect.append(aConnectedPeer)
      }
      if !peerToConnect.isEmpty {
        let invitedPeers = peerToConnect.map(\.name).joined(separator: ", ")
        print("[\(invitedPeers)] has been invited to joined the party 🚀")
        self?.transceiver.send(ServerMultipeerTransceiverAsk.connect, to: peerToConnect)
      }
    }
    transceiver.receive(Event<AnyCodable>.self) { [weak self] (event: Event<AnyCodable>, peer) in
      guard let self = self else { return }
      var obj = self.loggedClient[peer.id] ?? Client(peer: peer)
      obj.events[event.timestamp] = event
      self.loggedClient[peer.id] = obj
    }
    transceiver.receive(AppSession<AnyCodable>.self) {
      [weak self] (appSession: AppSession<AnyCodable>, peer) in
      guard let self = self else { return }
      var obj = self.loggedClient[peer.id] ?? Client(peer: peer)
      obj.sessions[appSession.id.uuidString] = appSession
      self.loggedClient[peer.id] = obj
    }

    transceiver.receive([String].self) { [weak self] (sessions: [String], peer) in
      guard let self = self else { return }
      var obj = self.loggedClient[peer.id] ?? Client(peer: peer)
      obj.sessionFiles = sessions
      self.loggedClient[peer.id] = obj
    }

    transceiver.receive(AppContext.self) { [weak self] (context: AppContext, peer) in
      guard let self = self else { return }
      var obj = self.loggedClient[peer.id] ?? Client(peer: peer)
      obj.context = context
      self.loggedClient[peer.id] = obj
      self.transceiver.send(ServerMultipeerTransceiverAsk.live, to: [peer])
    }

    transceiver.receive(ClientMultipeerTransceiverAsk.self) {
      [weak self] (ask: ClientMultipeerTransceiverAsk, peer) in
      switch ask {
      case .register:
        self?.transceiver.send(ServerMultipeerTransceiverAsk.connect, to: [peer])
        self?.transceiver.send(ServerMultipeerTransceiverAsk.live, to: [peer])
      }
    }
  }
}
