//
//  CityListView.swift
//  CitiesApp
//
//  Created by jvic on 04/01/25.
//

import SwiftUI

struct CityListView: View {
    @State var viewModel: CityListVM

    var body: some View {
        NavigationSplitView() {
            CityListContentView(viewModel: viewModel)
                .searchable(text: $viewModel.searchText)
                .navigationTitle("Cities")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewModel.toggleFavoritesOnly()
                        } label: {
                            Text("Favorites")
                        }
                        .buttonStyle(.bordered)
                        .tint(viewModel.showFavoritesOnly ? .accentColor : nil)
                    }
                }   
                .task {
                    do {
                        try await viewModel.connect()
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
                .sheet(isPresented: $viewModel.config.isShowingMoreInfo,
                       onDismiss: viewModel.didDismissMoreInfo) {
                    if let selectedCity = viewModel.config.selectedCity {
                        CityInformationView(config: .init(cityName: selectedCity.displayName, country: selectedCity.country, coord: selectedCity.coord))
                    }
                }
        } detail: {
            Text("No city selected").font(.subheadline).foregroundStyle(.gray)
        }
    }
}

struct CityListContentView: View {
    var viewModel: CityListVM

    var body: some View {
        if viewModel.config.isLoading {
            ProgressView()
        } else {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.filteredCities) { item in
                        CityListRow(config: item,
                                didTapMoreInfo: viewModel.didTapMoreInfo,
                                didTapFavorite: viewModel.didTapFavorite)
                    }
                }
            }
        }
    }
}

#Preview {
    CityListView(viewModel: CityListVM(repository: CityRepository(service: CityService())))
}
