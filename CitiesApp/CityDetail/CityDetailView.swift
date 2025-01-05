import SwiftUI
import MapKit

struct CityDetailView: View {
    @State var viewModel: CityDetailVM
    @State private var showingInformation = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Map(coordinateRegion: $viewModel.region, annotationItems: [viewModel.city]) { city in
                    MapMarker(coordinate: city.coordinate)
                }
                .frame(height: 300)
                
                VStack(alignment: .leading, spacing: 8) {
                    Group {
                        Text(viewModel.city.name)
                            .font(.title)
                        Text(viewModel.city.country)
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        HStack {
                            Text("Lat: \(viewModel.formattedCoordinates.lat)")
                            Text("Lon: \(viewModel.formattedCoordinates.lon)")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }

                    Group {
                        Button(action: {
                            showingInformation = true
                        }) {
                            HStack {
                                Text("More Info")
                                Image(systemName: "info.circle")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.top)
                }
                .padding()
            }
        }
        .navigationTitle(viewModel.city.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingInformation) {
            CityInformationView(viewModel: viewModel)
        }
    }
} 
