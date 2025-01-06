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
            VStack {
                List(viewModel.filteredCityViewModels) { cityVM in
                    HStack {
                        Button(action: {
                            viewModel.toggleFavorite(cityVM.id)
                        }) {
                            Image(systemName: viewModel.isFavorite(cityVM.id) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                        NavigationLink(destination: CityDetailView(viewModel: CityDetailVM(city: cityVM.city))) {
                            Text(cityVM.displayName)
                        }
                    }
                }
                .id(UUID())
                .listStyle(PlainListStyle())
            }
            .searchable(text: $viewModel.searchText)
            .navigationTitle("Cities")
            .task {
                do {
                    try await viewModel.connect()
                }
                catch {
                    print("ERROR")
                }
            }
        }
    }
}

#Preview {
    CityListView(viewModel: CityListVM(repository: CityRepository(service: CityService())))
}
