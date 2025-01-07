import Foundation

struct CityListConfig {
    var isLoading: Bool
    var isShowingMoreInfo: Bool
    let selectedCity: City?
    
    init(isLoading: Bool = false, isShowingMoreInfo: Bool = false, selectedCity: City? = nil) {
        self.isLoading = isLoading
        self.isShowingMoreInfo = isShowingMoreInfo
        self.selectedCity = selectedCity
    }
} 
