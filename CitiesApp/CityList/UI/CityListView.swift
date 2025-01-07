//
//  CityListView.swift
//  CitiesApp
//
//  Created by jvic on 04/01/25.
//

import SwiftUI

struct CityListView: View {
    @State var viewModel: CityListVM
    @State private var hasLoaded = false

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.filteredCityViewModels) { cityVM in
                            CityRow(viewModel: cityVM, didTapMoreInfo: viewModel.didTapMoreInfo)
                        }
                    }
                }
            }
            .searchable(text: $viewModel.searchText)
            .navigationTitle("Cities")
            .task {
                if !hasLoaded {
                    do {
                        try await viewModel.connect()
                        hasLoaded = true
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingInformation,
                   onDismiss: viewModel.didDismissMoreInfo) {
                if let selectedCity = viewModel.selectedCity {
                    CityInformationView(viewModel: CityDetailVM(city: selectedCity))
                }
            }
        }
    }
}


private struct CityRow: View {
    @State var viewModel: CityRowVM
    let didTapMoreInfo: (City) -> Void

    var body: some View {
        NavigationLink(destination: CityDetailView(city: viewModel.city)) {
            VStack {
                Divider()
                HStack {
                    Button(action: {
                        viewModel.toggleFavorite(viewModel.city.id)
                    }) {
                        Image(systemName: viewModel.imageIconName)
                            .foregroundColor(.yellow)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal)

                    VStack(alignment: .leading) {
                        Text(viewModel.displayName)
                        Text("Lat: \(viewModel.city.coord.lat), Lon: \(viewModel.city.coord.lon)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button {
                        didTapMoreInfo(viewModel.city)
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


#Preview {
    CityListView(viewModel: CityListVM(repository: CityRepository(service: CityService())))
}
