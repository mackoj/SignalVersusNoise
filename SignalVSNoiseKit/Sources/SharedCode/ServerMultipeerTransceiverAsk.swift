import Foundation

public enum DebuggerType: String, RawRepresentable, Codable {
  case server
  case client
  case unknown
}

public enum ServerMultipeerTransceiverAsk: Codable {
  case appContext
  case session(String)
  case allSessions
  case disconnect
  case live
  case connect
}
