import Foundation

protocol CityServiceProtocol {
    func fetchCities() async throws -> [City]
    func getFavoriteCities() -> Set<Int>
    func toggleFavorite(_ cityId: Int)
}

class CityService: CityServiceProtocol {
    private let citiesURL = URL(string: "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json")!
    private let favoritesKey = "FavoriteCities"
    private var isLoading = false

    func fetchCities() async throws -> [City] {
        let request = URLRequest(url: citiesURL)
        return try await fetch(request: request)
    }

    func fetchLocalCities() async throws -> [City] {
        guard let citiesPath = Bundle.main.path(forResource: "cities", ofType: "json"),
              let citiesData = FileManager.default.contents(atPath: citiesPath) else {
            throw NSError(domain: "CityService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Local cities.json file not found"])
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([City].self, from: citiesData)
    }

    private func fetch<T: Decodable>(request: URLRequest) async throws -> T {
        let (data, _) = try await URLSession.shared.data(for: request)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode(T.self, from: data)
    }

    func getFavoriteCities() -> Set<Int> {
        let array = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
        return Set(array)
    }
    
    func toggleFavorite(_ cityId: Int) {
        var favorites = getFavoriteCities()
        if favorites.contains(cityId) {
            favorites.remove(cityId)
        } else {
            favorites.insert(cityId)
        }
        UserDefaults.standard.set(Array(favorites), forKey: favoritesKey)
    }
} 
