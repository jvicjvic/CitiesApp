//
//  CityRepository.swift
//  CitiesApp
//
//  Created by jvic on 04/01/25.
//


class CityRepository {
    private let service: CityService

    init(service: CityService) {
        self.service = service
    }

    func fetchCities() async throws -> [City] {
        let allCities = try await service.fetchLocalCities()
        return allCities.sorted { $0.name < $1.name }
    }

    func toggleFavorite(_ cityId: Int) {
        service.toggleFavorite(cityId)
    }

    func isFavorite(_ cityId: Int) -> Bool {
        service.getFavoriteCities().contains(cityId)
    }
}
