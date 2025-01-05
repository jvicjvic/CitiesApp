import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            CityListView(viewModel: CityListVM(service: CityService()))
        }
    }
}

#Preview {
    ContentView()
}
