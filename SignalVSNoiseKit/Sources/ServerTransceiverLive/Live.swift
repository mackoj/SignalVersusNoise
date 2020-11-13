import Foundation
import ServerTransceiver
import UIKit

extension ServerTransceiver {
  public static var prod:
    (
      _ peerName: String, _ defaultQueue: OperationQueue?, _ center: NotificationCenter,
      _ bundle: Bundle, _ fManager: FileManager
    ) -> Self = {
      return Self.live(
        $0,
        $1,
        $2,
        $3,
        $4,
        false
      )
    }

  public static var preprod:
    (
      _ peerName: String, _ defaultQueue: OperationQueue?, _ center: NotificationCenter,
      _ bundle: Bundle, _ fManager: FileManager
    ) -> Self = {
      return Self.live(
        $0,
        $1,
        $2,
        $3,
        $4,
        true
      )
    }
}
