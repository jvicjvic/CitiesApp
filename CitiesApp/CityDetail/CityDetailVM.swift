import MapKit
import Observation

@Observable
final class CityDetailVM {
    let city: City

    init(city: City) {
        self.city = city
    }
    
    var formattedCoordinates: (lat: String, lon: String) {
        (
            String(format: "%.4f", city.coord.lat),
            String(format: "%.4f", city.coord.lon)
        )
    }
} 
