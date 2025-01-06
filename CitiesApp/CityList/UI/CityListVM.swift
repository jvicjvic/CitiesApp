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
    var searchText: String = "" {
        didSet {
            if oldValue != searchText {
                didSearch()
            }
        }
    }
    private let repository: CityRepository
    private var searchTask: Task<Void, Never>?
    
    init(repository: CityRepository) {
        self.repository = repository
    }
    
    func connect() async throws {
        cities = try await repository.fetchCities().map { CityItemVM(city: $0) }
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
    
    func toggleFavorite(_ cityId: Int) {
        repository.toggleFavorite(cityId)
    }
    
    func isFavorite(_ cityId: Int) -> Bool {
        repository.isFavorite(cityId)
    }
}


final class CityItemVM: Identifiable {
    let city: City

    init(city: City) {
        self.city = city
    }

    var displayName: String {
        city.displayName
    }

    var id: Int {
        city.id
    }

    func startsWith(_ prefix: String) -> Bool {
        displayName.lowercased().hasPrefix(prefix.lowercased())
    }
}
