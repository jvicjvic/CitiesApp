import Foundation

@MainActor
class CityDataManager: ObservableObject {
    @Published var isPreloading = true
    private let cityService: CityServiceProtocol
    
    init(cityService: CityServiceProtocol) {
        self.cityService = cityService
        Task {
            await preloadData()
        }
    }
    
    private func preloadData() async {
//        do {
//            _ = try await cityService.fetchCities()
//        } catch {
//            print("Preload failed: \(error.localizedDescription)")
//        }
        isPreloading = false
    }
} 
