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
            filterCities()
        }
    }
    private let service: CityService

    init(service: CityService) { // TODO: replace with repo
        self.service = service
    }

    func connect() async throws {
        cities = try await service.fetchLocalCities() //service.fetchCities()
        filterCities()
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
