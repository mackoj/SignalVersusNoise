import Combine
import Foundation

extension ServerTransceiver {
  public static var preview: Self = Self(
    serverName: "Preview Server",
    clientPublisher: Empty<Clients, Never>().eraseToAnyPublisher(),
    sendAction: { _, _ in },
    start: {},
    stop: {}
  )
}
