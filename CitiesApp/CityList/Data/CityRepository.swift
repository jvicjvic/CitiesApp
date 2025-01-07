//
//  CityRepository.swift
//  CitiesApp
//
//  Created by jvic on 04/01/25.
//


class CityRepository {
    private let service: CityService
    private var cachedCities: [String: [City]]?
    private var sortedCachedCities: [City]?

    init(service: CityService) {
        self.service = service
    }

    func fetchCities() async throws -> [City] {
        if let sortedCachedCities {
            return sortedCachedCities
        }
        let allCities = try await service.fetchCities().sorted { $0.name < $1.name }
        
        var citiesByFirstLetter: [String: [City]] = [:]
        for city in allCities {
            let firstLetter = String(city.name.prefix(1)).uppercased()
            citiesByFirstLetter[firstLetter, default: []].append(city)
        }
        
        cachedCities = citiesByFirstLetter
        sortedCachedCities = allCities
        return allCities
    }

    func fetchCities(startsWith prefix: String) async throws -> [City] {
        let uppercasePrefix = prefix.uppercased()
        let firstLetter = String(uppercasePrefix.prefix(1))
        
        if cachedCities == nil {
            _ = try await fetchCities()
        }
        
        guard let citiesWithSameFirstLetter = cachedCities?[firstLetter] else {
            return []
        }
        
        return citiesWithSameFirstLetter.filter {
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
