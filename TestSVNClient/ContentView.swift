import SwiftUI
import ComposableArchitecture

struct ContentView: View {
  let store : Store<AppState, AppAction>
  var body: some View {
    WithViewStore(self.store.scope(state: \.counter)) { viewStore in
      Text("Hello, world!").padding()
      Button(action: {
        viewStore.send(.inc)
      }, label: {
        Text("Increment")
      })
      Button(action: {
        viewStore.send(.dec)
      }, label: {
        Text("Decrement")
      })
    }
  }
}

//struct ContentView_Previews: PreviewProvider {
//  static var previews: some View {
//    ContentView()
//  }
//}
