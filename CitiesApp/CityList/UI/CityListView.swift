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
                ScrollView {
                    CityListContent(viewModel: viewModel)
                }
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

private struct CityListContent: View {
    var viewModel: CityListVM

    var body: some View {
        LazyVStack {
            ForEach(viewModel.filteredCityViewModels) { cityVM in
                NavigationLink(destination: CityDetailView(viewModel: CityDetailVM(city: cityVM.city))) {
                    CityRow(viewModel: cityVM)
                    Text(cityVM.displayName)
                }
            }
        }
    }
}

private struct CityRow: View {
    var viewModel: CityItemVM

    var body: some View {
        Button(action: {
            viewModel.toggleFavorite(viewModel.city.id)
        }) {
            Image(systemName: viewModel.imageIconName)
                .foregroundColor(.yellow)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
