import SwiftUI
import MapKit

struct CityDetailView: View {
    let config: CityInformationConfig
    @State private var cameraPosition: MapCameraPosition

    init(city: City) {
        self.config = CityInformationConfig(
            cityName: city.name,
            country: city.country,
            coord: city.coord
        )
        _cameraPosition = State(initialValue: .region(
            MKCoordinateRegion(
                center: city.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            )
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Map(position: $cameraPosition) {
                    Marker(config.cityName, coordinate: CLLocationCoordinate2D(
                        latitude: config.coord.lat,
                        longitude: config.coord.lon
                    ))
                }
                .frame(height: 300)
                
                VStack(alignment: .leading, spacing: 8) {
                    Group {
                        Text(config.cityName)
                            .font(.title)
                        Text(config.country)
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        HStack {
                            Text("Lat: \(config.formattedCoordinates.lat)")
                            Text("Lon: \(config.formattedCoordinates.lon)")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(config.cityName)
        .navigationBarTitleDisplayMode(.inline)
    }
} 
