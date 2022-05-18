import Foundation

extension Source {
  public enum AppLifeCycle: Codable {
    case didEnterBackground
    case willEnterForeground
    case didFinishLaunching
    case didBecomeActive
    case willResignActive
    case didReceiveMemoryWarning
    case willTerminate
    case significantTimeChange
    case backgroundRefreshStatusDidChange
    case protectedDataWillBecomeUnavailable
    case protectedDataDidBecomeAvailable
    case userDidTakeScreenshot
    case crash(CrashModel)
  }
}
