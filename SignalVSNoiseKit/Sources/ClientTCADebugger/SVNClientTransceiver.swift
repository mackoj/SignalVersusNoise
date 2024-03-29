import AnyCodable
import Foundation
import MultipeerKit
import SharedCode
import UIKit

extension NSNotification.Name {
  public static let deviceDidShakeNotification = NSNotification.Name(
    "ShakeItShakeShakeItShakeItOhOh")
}

extension UIWindow {
  open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    super.motionEnded(motion, with: event)
    NotificationCenter.default.post(name: .deviceDidShakeNotification, object: event)
  }
}

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
    center.addObserver(forName: .deviceDidShakeNotification, object: nil, queue: queue) {
      [weak self] _ in
      self?.transceiver.broadcast(ClientMultipeerTransceiverAsk.askForAttention)
    }
  }

  public func sendAllSessions(_ peer: Peer? = nil) {
    do {
      let files = try self.fileManager.contentsOfDirectory(
        atPath: self.defaultDocumentURL().path)
      var sessions: [String: AppSession<AnyCodable>] = [:]
      let decoder = JSONDecoder()
      for aFile in files {
        let fileURL = try self.defaultDocumentURL().appendingPathComponent(aFile)
        let obj = try decoder.decode(
          AppSession<AnyCodable>.self,
          from: try Data(
            contentsOf: fileURL
          )
        )
        sessions[aFile] = obj
      }
      if peer == nil {
        self.transceiver.broadcast(sessions)
      } else {
        self.transceiver.send(sessions, to: [peer!])
      }
    } catch {
      dump(error)
    }
  }

  func respondToTransceiver() {
    transceiver.receive(ServerMultipeerTransceiverAsk.self) {
      [weak self] (ask: ServerMultipeerTransceiverAsk, peer) in
      guard let self = self else { return }
      switch ask {
      case .live:
        self.isLive = !self.isLive
        self.transceiver.broadcast(DebuggerType.client)

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
        self.sendAllSessions(peer)

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
