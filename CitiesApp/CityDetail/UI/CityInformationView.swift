import SwiftUI

struct CityInformationView: View {
    let config: CityInformationConfig
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Location") {
                    InfoRow(title: "City", value: config.cityName)
                    InfoRow(title: "Country", value: config.country)
                }
                
                Section("Coordinates") {
                    InfoRow(title: "Latitude", value: config.formattedCoordinates.lat)
                    InfoRow(title: "Longitude", value: config.formattedCoordinates.lon)
                }
            }
            .navigationTitle("City Information")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
        }
    }
}
