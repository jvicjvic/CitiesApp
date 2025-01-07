//
//  CityListVM.swift
//  CitiesApp
//
//  Created by jvic on 04/01/25.
//

import Observation
import Foundation

@Observable
@MainActor
final class CityListVM {
    var config = CityListConfig()
    
    @ObservationIgnored var cities: [CityRowConfig] = []
    var filteredCities: [CityRowConfig] = []
    
    private var searchTask: Task<Void, Never>?
    var searchText: String = "" {
        didSet {
            if oldValue != searchText {
                didSearch()
            }
        }
    }

    private let repository: CityRepository

    init(repository: CityRepository) {
        self.repository = repository
    }

    func connect() async throws {
        didSearch()
    }

    func didSearch() {
        searchTask?.cancel()
        searchTask = Task {
            // debounce search
            try? await Task.sleep(nanoseconds: 500_000_000) // 500ms
            if !Task.isCancelled {
                do {
                    filteredCities = try await self.filterCities()
                }
                catch {
                    print("Error: \(error)")
                }
            }
        }
    }

    private nonisolated func filterCities() async throws -> [CityRowConfig] {
        let fetchedCities: [City]

        if await searchText.isEmpty {
            fetchedCities = try await repository.fetchCities()
        } else {
            fetchedCities = try await repository.fetchCities(startsWith: searchText)
        }

        let repo = await repository

        return fetchedCities.map { newCity in
            CityRowConfig(city: newCity, isFavorite: repo.isFavorite(newCity.id))
        }
    }

    func didTapFavorite(_ city: City) {
        repository.toggleFavorite(city.id)
    }

    func didTapMoreInfo(_ city: City) {
        config = CityListConfig(isShowingMoreInfo: true, selectedCity: city)
    }

    func didDismissMoreInfo() {
        config = CityListConfig()
    }
}
