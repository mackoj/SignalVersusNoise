import SwiftUI
import ComposableArchitecture

struct ContentView: View {
  let store : Store<AppState, AppAction>
  var body: some View {
    WithViewStore(self.store.scope(state: \.counter)) { viewStore in
      Text("Hello, world!").padding()
    }
  }
}

//struct ContentView_Previews: PreviewProvider {
//  static var previews: some View {
//    ContentView()
//  }
//}
