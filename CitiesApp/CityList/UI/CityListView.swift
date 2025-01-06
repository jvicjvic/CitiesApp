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
                    CityListContent(viewModel: viewModel)
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
        }
    }
}

private struct CityListContent: View {
    var viewModel: CityListVM

    var body: some View {
        LazyVStack {
            ForEach(viewModel.filteredCityViewModels) { cityVM in
                CityRow(viewModel: cityVM)
            }
        }
    }
}

private struct CityRow: View {
    @State var viewModel: CityItemVM

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
                }
            }

        }
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    CityListView(viewModel: CityListVM(repository: CityRepository(service: CityService())))
}
