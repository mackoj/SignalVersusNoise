import AnyCodable
import Combine
import Foundation
import MultipeerKit
import SharedCode

public struct ServerTransceiver {
  public typealias Clients = [String: Client]
  public var serverName: String
  public var clientPublisher: AnyPublisher<Clients, Never>
  public var sendAction: (Client, Action) -> Void
  public var start: () -> Void
  public var stop: () -> Void

  public init(
    serverName: String,
    clientPublisher: AnyPublisher<Clients, Never>,
    sendAction: @escaping (ServerTransceiver.Client, ServerTransceiver.Action) -> Void,
    start: @escaping () -> Void,
    stop: @escaping () -> Void
  ) {
    self.serverName = serverName
    self.clientPublisher = clientPublisher
    self.sendAction = sendAction
    self.start = start
    self.stop = stop
  }

  public struct Client: Equatable {
    public let peer: Peer
    public var dType: DebuggerType = .unknown
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

  public enum Action {

  }
}

/*
 /// Handles all aspects related to the multipeer communication.
 public final class MultipeerTransceiver {

     internal let connection: MultipeerProtocol

     /// Called on the main queue when available peers have changed (new peers discovered or peers removed).
     public var availablePeersDidChange: ([Peer]) -> Void

     /// Called on the main queue when a new peer discovered.
     public var peerAdded: (Peer) -> Void

     /// Called on the main queue when a peer removed.
     public var peerRemoved: (Peer) -> Void

     /// The current device's peer id
     public var localPeerId: String? { get }

     /// All peers currently available for invitation, connection and data transmission.
     public private(set) var availablePeers: [Peer] { get set }

     /// Initializes a new transceiver.
     /// - Parameter configuration: The configuration, uses the default configuration if none specified.
     public init(configuration: MultipeerConfiguration = .default)

     internal init(connection: MultipeerProtocol)

     /// Configures a new handler for a specific `Codable` type.
     /// - Parameters:
     ///   - type: The `Codable` type to receive.
     ///   - closure: The closure that will be called whenever a payload of the specified type is received.
     ///   - payload: The payload decoded from the remote message.
     ///   - sender: The remote peer who sent the message.
     ///
     /// MultipeerKit communicates data between peers as JSON-encoded payloads which originate with
     /// `Codable` entities. You register a closure to handle each specific type of entity,
     /// and this closure is automatically called by the framework when a remote peer sends
     /// a message containing an entity that decodes to the specified type.
     public func receive<T>(_ type: T.Type, using closure: @escaping (_ payload: T, _ sender: Peer) -> Void) where T : Decodable, T : Encodable

     /// Resumes the transceiver, allowing this peer to be discovered and to discover remote peers.
     public func resume()

     /// Stops the transceiver, preventing this peer from discovering and being discovered.
     public func stop()

     /// Sends a message to all connected peers.
     /// - Parameter payload: The payload to be sent.
     public func broadcast<T>(_ payload: T) where T : Encodable

     /// Sends a message to a specific peer.
     /// - Parameters:
     ///   - payload: The payload to be sent.
     ///   - peers: An array of peers to send the message to.
     public func send<T>(_ payload: T, to peers: [Peer]) where T : Encodable

     /// Manually invite a peer for communicating.
     /// - Parameters:
     ///   - peer: The peer to be invited.
     ///   - context: Custom data to be sent alongside the invitation.
     ///   - timeout: How long to wait for the remote peer to accept the invitation.
     ///   - completion: Called when the invitation succeeds or fails.
     ///
     /// You can call this method to manually invite a peer for communicating if you set the
     /// `invitation` parameter to `.none` in the transceiver's `configuration`.
     ///
     /// - warning: If the invitation parameter is not set to `.none`, you shouldn't call this method,
     /// since the transceiver does the inviting automatically.
     public func invite(_ peer: Peer, with context: Data?, timeout: TimeInterval, completion: InvitationCompletionHandler?)
 }

 */

/*
 import Combine
 import Foundation

 public struct StatClient {
   public typealias Context = [String: String]
   public struct Tag {
     public init(key: String, properties: [String: String]) {
       self.key = key
       self.properties = properties
     }
     public let key: String
     public let properties: [String: String]
   }

   public var update: (_ ctx: Context) -> Void  // not sur I want to keep it if we don't use it after the MVP we will remove it
   public var allContext: () -> Context
   public var contextValue: (String) -> String
   public var track: (Tag) -> Void
   public var delegate: AnyPublisher<TrackerEvent, Never>

   public init(
     update: @escaping (StatClient.Context) -> Void,
     allContext: @escaping () -> Context,
     contextValue: @escaping (String) -> String,
     track: @escaping (StatClient.Tag) -> Void,
     delegate: AnyPublisher<TrackerEvent, Never>
   ) {
     self.update = update
     self.allContext = allContext
     self.contextValue = contextValue
     self.track = track
     self.delegate = delegate
   }

   // Event that the delegate of ATInternetTracker can send
   public enum TrackerEvent {
     case trackerNeedsFirstLaunchApproval(String)
     case buildDidEnd(ProxyHitStatus, String)
     case sendDidEnd(ProxyHitStatus, String)
     case saveDidEnd(String)
     case didCallPartner(String)
     case warningDidOccur(String)
     case errorDidOccur(String)
   }

   // Proxy for HitStatus the goal is to prevent importing `ATInternetTracker`
   public enum ProxyHitStatus: Int {
     case failed = 0
     case success = 1
   }
 }

 */
