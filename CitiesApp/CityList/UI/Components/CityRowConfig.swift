import Foundation

struct CityRowConfig: Identifiable {
    let city: City

    var id: Int {
        city.id
    }

    var displayName: String {
        city.displayName
    }

    let isFavorite: Bool
} 