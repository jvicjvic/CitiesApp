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
    var filteredCities: [CityRowConfig] = []
    var showFavoritesOnly: Bool = false
    
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
        config = CityListConfig(isLoading: true)
        searchTask?.cancel()
        searchTask = Task {
            // debounce search
            try? await Task.sleep(nanoseconds: 500_000_000) // 500ms
            if !Task.isCancelled {
                do {
                    let list = try await showFavoritesOnly ? filterFavoriteCities() : filterCities()
                    if !Task.isCancelled {
                        filteredCities = list
                        config = CityListConfig(isLoading: false)
                    }
                }
                catch {
                    print("Error: \(error)")
                }
            }
        }
    }

    /// Does the fetching and filtering of the cities
    private nonisolated func filterCities(favorites: Bool = false) async throws -> [CityRowConfig] {
        let fetchedCities: [City]
        
        if await searchText.isEmpty {
            fetchedCities = favorites ? 
                await repository.fetchFavoriteCities() :
                try await repository.fetchCities()
        } else {
            fetchedCities = favorites ?
                await repository.fetchFavoriteCities(startsWith: searchText) :
                try await repository.fetchCities(startsWith: searchText)
        }

        let repo = await repository

        return fetchedCities.map { newCity in
            CityRowConfig(city: newCity, isFavorite: favorites ? true : repo.isFavorite(newCity))
        }
    }

    private nonisolated func filterFavoriteCities() async throws -> [CityRowConfig] {
        return try await filterCities(favorites: true)
    }

    func didTapFavorite(_ city: City) {
        repository.toggleFavorite(city)
    }

    func didTapMoreInfo(_ city: City) {
        config = CityListConfig(isShowingMoreInfo: true, selectedCity: city)
    }

    func didDismissMoreInfo() {
        config = CityListConfig()
    }

    func toggleFavoritesOnly() {
        showFavoritesOnly.toggle()
        didSearch()
    }
}
