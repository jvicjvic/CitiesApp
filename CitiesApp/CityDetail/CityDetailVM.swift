import MapKit
import Observation

@Observable
final class CityDetailVM {
    let city: City
    var region: MKCoordinateRegion
    
    init(city: City) {
        self.city = city
        self.region = MKCoordinateRegion(
            center: city.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
    }
    
    var formattedCoordinates: (lat: String, lon: String) {
        (
            String(format: "%.4f", city.coord.lat),
            String(format: "%.4f", city.coord.lon)
        )
    }
} 