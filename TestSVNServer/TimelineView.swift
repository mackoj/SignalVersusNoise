import SwiftUI
import ComposableArchitecture

struct TimelineView: View {
    let store : Store<TimelineState, TimelineAction>
    var body: some View {
//        WithViewStore(self.store) { viewStore in
            Text("Timeline")
//        }
    }
}

//struct TimelineView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimelineView()
//    }
//}
