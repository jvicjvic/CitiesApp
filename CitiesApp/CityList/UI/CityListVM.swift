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
    private let service: CityService

    init(service: CityService) { // TODO: replace with repo
        self.service = service
    }

    func connect() async throws {
        cities = try await service.fetchLocalCities() //service.fetchCities()
    }
}
