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
                List {
                    ForEach(viewModel.filteredCities) { city in
                        Text(city.displayName)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .searchable(text: $viewModel.searchText)
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
    CityListView(viewModel: CityListVM(service: CityService()))
}
