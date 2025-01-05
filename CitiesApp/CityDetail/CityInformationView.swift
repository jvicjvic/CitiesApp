import SwiftUI

struct CityInformationView: View {
    let viewModel: CityDetailVM
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Location") {
                    InfoRow(title: "City", value: viewModel.city.name)
                    InfoRow(title: "Country", value: viewModel.city.country)
                }
                
                Section("Coordinates") {
                    InfoRow(title: "Latitude", value: viewModel.formattedCoordinates.lat)
                    InfoRow(title: "Longitude", value: viewModel.formattedCoordinates.lon)
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