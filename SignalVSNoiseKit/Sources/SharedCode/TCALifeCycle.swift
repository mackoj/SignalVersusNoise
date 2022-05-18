import Foundation

extension Source {
  public enum TCALifeCycle: Codable {
    case beforeSendAction(String)  // whenever a action is send
    case afterSendAction(String, State)  // whenever a action is send
    case withViewStore(State)  // whenever the view is computed
    case stateChange(String, State)  // origin ??
    case swiftUIBodyUpdate(String, State)  // View
    case runtimeWarning(String)
  }
}
