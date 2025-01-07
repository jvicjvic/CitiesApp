import Foundation

struct CityInformationConfig {
    let cityName: String
    let country: String
    let coord: Coordinates

    var formattedCoordinates: (lat: String, lon: String) {
        (
            String(format: "%.4f", coord.lat),
            String(format: "%.4f", coord.lon)
        )
    }
} 
