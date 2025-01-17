import Foundation
import CoreLocation

struct City: Codable, Identifiable, Equatable, Hashable {
    let country: String
    let name: String
    let id: Int
    let coord: Coordinates
    
    enum CodingKeys: String, CodingKey {
        case country
        case name
        case id = "_id"
        case coord
    }
    
    var displayName: String {
        "\(name), \(country)"
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coord.lat, longitude: coord.lon)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Coordinates: Codable, Equatable, Hashable {
    let lon: Double
    let lat: Double
} 
