import XCTest
@testable import CitiesApp

@MainActor
final class CityListVMTests: XCTestCase {
    var viewModel: CityListVM!
    var repository: CityRepository!
    var mockService: MockCityService!
    
    override func setUpWithError() throws {
        mockService = MockCityService()
        repository = CityRepository(service: mockService)
        viewModel = CityListVM(repository: repository)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        repository = nil
        mockService = nil
    }
    
    func testConnect() async throws {
        // Given
        let expectedCities = [
            City(country: "US", name: "New York", id: 1, coord: Coordinates(lon: -74.006, lat: 40.7143))
        ]
        mockService.mockCities = expectedCities
        
        // When
        try await viewModel.connect()
        
        // Wait for the debounce
        try await Task.sleep(nanoseconds: 600_000_000)
        
        // Then
        XCTAssertEqual(viewModel.filteredCities.count, 1)
        XCTAssertEqual(viewModel.filteredCities[0].city.name, "New York")
    }
    
    func testSearch() async throws {
        // Given
        let cities = [
            City(country: "US", name: "New York", id: 1, coord: Coordinates(lon: -74.006, lat: 40.7143)),
            City(country: "FR", name: "Paris", id: 2, coord: Coordinates(lon: 2.3488, lat: 48.8534))
        ]
        mockService.mockCities = cities
        
        // When
        viewModel.searchText = "New"
        
        // Wait for the debounce
        try await Task.sleep(nanoseconds: 600_000_000)
        
        // Then
        XCTAssertEqual(viewModel.filteredCities.count, 1)
        XCTAssertEqual(viewModel.filteredCities[0].city.name, "New York")
    }
    
    func testToggleFavorite() async throws {
        // Given
        let city = City(country: "US", name: "New York", id: 1, coord: Coordinates(lon: -74.006, lat: 40.7143))
        mockService.mockCities = [city]
        
        // When
        viewModel.didTapFavorite(city)
        
        // Then
        XCTAssertTrue(repository.isFavorite(city))
    }
    
    func testShowFavoritesOnly() async throws {
        // Given
        let cities = [
            City(country: "US", name: "New York", id: 1, coord: Coordinates(lon: -74.006, lat: 40.7143)),
            City(country: "FR", name: "Paris", id: 2, coord: Coordinates(lon: 2.3488, lat: 48.8534))
        ]
        mockService.mockCities = cities
        viewModel.didTapFavorite(cities[0]) // Make New York favorite
        
        // When
        viewModel.toggleFavoritesOnly()
        
        // Wait for the debounce
        try await Task.sleep(nanoseconds: 600_000_000)
        
        // Then
        XCTAssertTrue(viewModel.showFavoritesOnly)
        XCTAssertEqual(viewModel.filteredCities.count, 1)
        XCTAssertEqual(viewModel.filteredCities[0].city.name, "New York")
    }
} 