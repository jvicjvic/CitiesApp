//
//  CityListVM.swift
//  CitiesApp
//
//  Created by jvic on 04/01/25.
//

import Observation

@Observable
@MainActor
final class CityListVM {
    @ObservationIgnored var cities: [CityItemVM] = []
    var filteredCityViewModels: [CityItemVM] = []

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
        cities = try await repository.fetchCities().map { CityItemVM(city: $0, repository: repository) }
        filterCities()
    }

    func didSearch() {
            searchTask?.cancel()
            searchTask = Task {
                // debounce search
                try? await Task.sleep(nanoseconds: 500_000_000) // 500ms
                if !Task.isCancelled {
                    filterCities()
                }
            }
    }

    private func filterCities() {
        if searchText.isEmpty {
            filteredCityViewModels = cities
            return
        }
        
        filteredCityViewModels = cities.filter {
            $0.startsWith(searchText)
        }
    }
}

@Observable
@MainActor
final class CityItemVM: Identifiable {
    let city: City

    var displayName: String {
        city.displayName
    }

    var imageIconName = "star"

    private let repository: CityRepository

    init(city: City, repository: CityRepository) {
        self.city = city
        self.repository = repository
        updateIcon()
    }

    func startsWith(_ prefix: String) -> Bool {
        displayName.lowercased().hasPrefix(prefix.lowercased())
    }

    func toggleFavorite(_ cityId: Int) {
        repository.toggleFavorite(cityId)
        updateIcon()
    }

    func isFavorite(_ cityId: Int) -> Bool {
        repository.isFavorite(cityId)
    }

    private func updateIcon() {
        self.imageIconName = isFavorite(city.id) ? "star.fill" : "star"
    }
}
