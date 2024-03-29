#if canImport(UIKit)
  import Foundation
  import UIKit
  import AnyCodable
  import SharedCode

  extension SVNClientTransceiver {
    func registerDidEnterBackgroundNotification() {
      notificationCenter.addObserver(
        forName: UIApplication.willResignActiveNotification,
        object: nil,
        queue: self.queue
      ) { [weak self] note in
        guard let self = self else { return }

        do {
          let url = try self.defaultDocumentURL().appendingPathComponent(
            "\(self.currentSession.id.uuidString).json")
          try JSONEncoder().encode(self.currentSession).write(to: url)
          print(url.path)
        } catch {
          dump(error)
        }
      }
    }

    var notifications: [Notification.Name: Source<AnyCodable>] {
      [
        UIApplication.backgroundRefreshStatusDidChangeNotification: .appLifeCycle(
          .backgroundRefreshStatusDidChange),
        UIApplication.didBecomeActiveNotification: .appLifeCycle(.didBecomeActive),
        UIApplication.didEnterBackgroundNotification: .appLifeCycle(.didEnterBackground),
        UIApplication.didFinishLaunchingNotification: .appLifeCycle(.didFinishLaunching),
        UIApplication.didReceiveMemoryWarningNotification: .appLifeCycle(.didReceiveMemoryWarning),
        UIApplication.protectedDataDidBecomeAvailableNotification: .appLifeCycle(
          .protectedDataDidBecomeAvailable),
        UIApplication.protectedDataWillBecomeUnavailableNotification: .appLifeCycle(
          .protectedDataWillBecomeUnavailable),
        UIApplication.significantTimeChangeNotification: .appLifeCycle(.significantTimeChange),
        UIApplication.userDidTakeScreenshotNotification: .appLifeCycle(.userDidTakeScreenshot),
        UIApplication.willEnterForegroundNotification: .appLifeCycle(.willEnterForeground),
        UIApplication.willResignActiveNotification: .appLifeCycle(.willResignActive),
        UIApplication.willTerminateNotification: .appLifeCycle(.willTerminate),
      ]
    }

    func listenAppLifeCycle() {
      for notification in notifications {
        notificationCenter.addObserver(
          forName: notification.key,
          object: nil,
          queue: self.queue
        ) { [weak self] note in
          self?.recordEvent(notification.value)
        }
      }
    }
  }
#else
  extension SignalVSNoiseReporter {
    func listenAppLifeCycle() {}
    func saveSession() {}
    func registerDidEnterBackgroundNotification() {}
  }
#endif
