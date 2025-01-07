//
//  CitiesAppTests.swift
//  CitiesAppTests
//
//  Created by jvic on 04/01/25.
//

import XCTest
@testable import CitiesApp

final class CitiesAppTests: XCTestCase {
    var repository: CityRepository!
    var mockService: MockCityService!
    
    override func setUpWithError() throws {
        mockService = MockCityService()
        repository = CityRepository(service: mockService)
    }
    
    override func tearDownWithError() throws {
        repository = nil
        mockService = nil
    }
    
    func testFetchCities() async throws {
        let expectedCities = [
            City(country: "US", name: "New York", id: 1, coord: Coordinates(lon: -74.006, lat: 40.7143)),
            City(country: "UK", name: "London", id: 2, coord: Coordinates(lon: -0.1257, lat: 51.5085))
        ]
        mockService.mockCities = expectedCities

        let cities = try await repository.fetchCities()

        XCTAssertEqual(cities.count, 2)
        XCTAssertEqual(cities[0].name, "London") // Should be sorted alphabetically
        XCTAssertEqual(cities[1].name, "New York")
    }
    
    func testFetchCitiesWithFilter() async throws {
        let expectedCities = [
            City(country: "US", name: "New York", id: 1, coord: Coordinates(lon: -74.006, lat: 40.7143)),
            City(country: "US", name: "New Orleans", id: 2, coord: Coordinates(lon: -90.0751, lat: 29.9546))
        ]
        mockService.mockCities = expectedCities

        let cities = try await repository.fetchCities(startsWith: "New")

        XCTAssertEqual(cities.count, 2)
        XCTAssertTrue(cities.allSatisfy { $0.name.hasPrefix("New") })
    }
    
    func testToggleFavorite() async throws {
        let city = City(country: "US", name: "New York", id: 1, coord: Coordinates(lon: -74.006, lat: 40.7143))
        
        repository.toggleFavorite(city)
        
        XCTAssertTrue(repository.isFavorite(city))
        
        repository.toggleFavorite(city)
        
        XCTAssertFalse(repository.isFavorite(city))
    }
}

class MockCityService: CityServiceProtocol {
    var mockCities: [City] = []
    private var favoriteCities: Set<City> = []
    
    func fetchCities() async throws -> [City] {
        return mockCities
    }
    
    func getFavoriteCities() -> Set<City> {
        return favoriteCities
    }
    
    func toggleFavorite(_ city: City) {
        if favoriteCities.contains(city) {
            favoriteCities.remove(city)
        } else {
            favoriteCities.insert(city)
        }
    }
}
