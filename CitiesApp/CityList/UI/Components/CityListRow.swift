import SwiftUI

struct CityListRow: View {
    @State var config: CityRowConfig
    let didTapMoreInfo: (City) -> Void
    let didTapFavorite: (City) -> Void

    init(config: CityRowConfig, didTapMoreInfo: @escaping (City) -> Void, didTapFavorite: @escaping (City) -> Void) {
        _config = State(initialValue: config)
        self.didTapMoreInfo = didTapMoreInfo
        self.didTapFavorite = didTapFavorite
    }

    var body: some View {
        NavigationLink(destination: CityDetailView(city: config.city)) {
            VStack {
                Divider()
                HStack {
                    CityFavoriteButton(
                        isFavorite: config.isFavorite,
                        action: { newValue in
                            didTapFavorite(config.city)
                        }
                    )

                    VStack(alignment: .leading) {
                        Text(config.displayName)
                        Text("Lat: \(config.city.coord.lat), Lon: \(config.city.coord.lon)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button {
                        didTapMoreInfo(config.city)
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
} 
