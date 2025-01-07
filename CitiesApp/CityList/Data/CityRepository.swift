//
//  CityRepository.swift
//  CitiesApp
//
//  Created by jvic on 04/01/25.
//


class CityRepository {
    private let service: CityService
    private var cachedCities: [City]?

    init(service: CityService) {
        self.service = service
    }

    func fetchCities() async throws -> [City] {
        if let cachedCities {
            return cachedCities
        }
        let allCities = try await service.fetchCities().sorted { $0.name < $1.name }
        cachedCities = allCities
        return allCities
    }

    func fetchCities(startsWith prefix: String) async throws -> [City] {
        try await fetchCities().filter {
            $0.displayName.lowercased().hasPrefix(prefix.lowercased())
        }
    }

    func toggleFavorite(_ cityId: Int) {
        service.toggleFavorite(cityId)
    }

    func isFavorite(_ cityId: Int) -> Bool {
        service.getFavoriteCities().contains(cityId)
    }
}
