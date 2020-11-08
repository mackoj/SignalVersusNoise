//
//  ContentView.swift
//  TestSVNServer
//
//  Created by Jeffrey Macko on 08/11/2020.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
  let store : Store<AppState, AppAction>
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        Text("Hello, world!").padding()
        DeviceListView()
      }
    }
  }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
