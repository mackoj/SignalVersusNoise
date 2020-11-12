import AnyCodable
import Foundation
import MultipeerKit
import SharedCode

struct Constant {
  static let folder: String = "svn"
}

public class SVNClientTransceiver {
  var queue: OperationQueue?
  var notificationCenter: NotificationCenter
  var ud: UserDefaults
  var transceiver: MultipeerTransceiver
  var currentSession: AppSession<AnyCodable>
  var fileManager: FileManager
  var isLive = false

  public init<State: Codable>(
    _ stateType: State.Type,
    _ defaultQueue: OperationQueue? = nil,
    _ ud: UserDefaults = .standard,
    _ center: NotificationCenter = NotificationCenter.default,
    _ bundle: Bundle = .main,
    _ fileManager: FileManager = .default
  ) {
    var configuration: MultipeerConfiguration = .default
    configuration.security.encryptionPreference = .required
    configuration.serviceType = "svn-tca"
    configuration.defaults = ud
    notificationCenter = center
    queue = defaultQueue
    self.ud = ud
    self.fileManager = fileManager
    currentSession = AppSession(bundle, fileManager)
    transceiver = MultipeerTransceiver(configuration: configuration)
    transceiver.resume()
    registerDidEnterBackgroundNotification()
    respondToTransceiver()
    listenAppLifeCycle()
    transceiver.broadcast(ClientMultipeerTransceiverAsk.register)
    transceiver.broadcast(DebuggerType.client)
  }

  func respondToTransceiver() {
    transceiver.receive(ServerMultipeerTransceiverAsk.self) {
      [weak self] (ask: ServerMultipeerTransceiverAsk, peer) in
      guard let self = self else { return }
      switch ask {
      case .live:
        self.isLive = !self.isLive

      case .disconnect:
        self.transceiver.stop()

      case .appContext:
        self.transceiver.send(self.currentSession.appContext, to: [peer])

      case let .session(id):
        do {
          let sessionFileName = "\(id).json"
          let sessionFileURL = try self.defaultDocumentURL().appendingPathComponent(sessionFileName)
          if let data = self.fileManager.contents(atPath: sessionFileURL.path) {
            let session = try JSONDecoder().decode(AppSession<AnyCodable>.self, from: data)
            self.transceiver.send(session, to: [peer])
          }
        } catch {
          dump(error)
        }

      case .allSessions:
        do {
          let files = try self.fileManager.contentsOfDirectory(
            atPath: self.defaultDocumentURL().path)
          self.transceiver.send(files, to: [peer])
        } catch {
          dump(error)
        }

      case .connect:
        self.transceiver.send(self.currentSession.appContext, to: [peer])
      }
    }
  }
}

extension SVNClientTransceiver {
  public func recordEvent(_ source: Source<AnyCodable>) {
    DispatchQueue.main.async { [weak self] in
      let event = Event(source)
      self?.storeInSession(event)
      self?.broadcastEvent(event)
    }
  }

  func storeInSession(_ event: Event<AnyCodable>) {
    currentSession.addEvent(event)
  }

  func broadcastEvent(_ event: Event<AnyCodable>, _ peer: Peer? = nil) {
    if self.isLive {
      (peer != nil) ? transceiver.send(event, to: [peer!]) : transceiver.broadcast(event)
    }
  }

  func defaultDocumentURL() throws -> URL {
    let documentsPath = NSSearchPathForDirectoriesInDomains(
      .documentDirectory,
      .userDomainMask,
      true
    ).first!
    let documentURL = URL(fileURLWithPath: documentsPath)
    let svnFolder = documentURL.appendingPathComponent(Constant.folder, isDirectory: true)
    print(svnFolder)
    var directory: ObjCBool = ObjCBool(true)
    if !fileManager.fileExists(atPath: svnFolder.path, isDirectory: &directory) {
      try fileManager.createDirectory(
        at: svnFolder, withIntermediateDirectories: true, attributes: nil)
    }
    return svnFolder
  }
}
