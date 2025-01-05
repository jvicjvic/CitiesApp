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
        VStack {
            List {
                ForEach(viewModel.cities) { city in
                    Text(city.name)
                }
            }
            .listStyle(PlainListStyle())
        }
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

#Preview {
    CityListView(viewModel: CityListVM(service: CityService()))
}
