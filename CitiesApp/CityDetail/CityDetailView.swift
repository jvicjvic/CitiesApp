import SwiftUI
import MapKit

struct CityDetailView: View {
    @State var viewModel: CityDetailVM
    @State private var showingInformation = false
    @State private var cameraPosition: MapCameraPosition

    init(city: City) {
        _viewModel = State(initialValue: CityDetailVM(city: city))
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
                    Marker(viewModel.city.name, coordinate: viewModel.city.coordinate)
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
