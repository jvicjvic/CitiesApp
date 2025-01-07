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
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.filteredCities) { item in
                        CityListRow(config: item,
                                didTapMoreInfo: viewModel.didTapMoreInfo,
                                didTapFavorite: viewModel.didTapFavorite)
                    }
                }
            }
            .searchable(text: $viewModel.searchText)
            .navigationTitle("Cities")
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
        }
    }
}

#Preview {
    CityListView(viewModel: CityListVM(repository: CityRepository(service: CityService())))
}
