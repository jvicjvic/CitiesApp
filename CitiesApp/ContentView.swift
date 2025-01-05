import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            CityListView(viewModel: CityListVM(repository: CityRepository(service: CityService())))
        }
    }
}

#Preview {
    ContentView()
}
