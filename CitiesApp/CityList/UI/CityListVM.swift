//
//  CityListVM.swift
//  CitiesApp
//
//  Created by jvic on 04/01/25.
//

import Observation

@Observable
final class CityListVM {
    var cities: [City] = []
    var filteredCities: [City] = []
    var searchText: String = "" {
        didSet {
            Task {
                await debounceSearch()
            }
        }
    }
    private let repository: CityRepository
    private var searchTask: Task<Void, Never>?
    
    init(repository: CityRepository) {
        self.repository = repository
    }
    
    func connect() async throws {
        cities = try await repository.fetchCities()
        filterCities()
    }
    
    @MainActor
    private func debounceSearch() async {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000) // 300ms
            if !Task.isCancelled {
                filterCities()
            }
        }
    }
    
    private func filterCities() {
        if searchText.isEmpty {
            filteredCities = cities
            return
        }
        
        filteredCities = cities.filter {
            $0.displayName.lowercased().hasPrefix(searchText.lowercased())
        }
    }
}
