import Foundation

struct CityListConfig {
    var isShowingMoreInfo: Bool
    let selectedCity: City?
    
    init(isShowingMoreInfo: Bool = false, selectedCity: City? = nil) {
        self.isShowingMoreInfo = isShowingMoreInfo
        self.selectedCity = selectedCity
    }
} 