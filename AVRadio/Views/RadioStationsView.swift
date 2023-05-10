//
//  RadioStationsView.swift
//  AVRadio
//
//  Created by Artemy Volkov on 09.05.2023.
//

import SwiftUI

struct RadioStationsView: View {
    @AppStorage("keyColor") var keyColor = Color(#colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1))
    @EnvironmentObject var viewModel: RadioStationsViewModel
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else {
                    radioList 
                }
            }
            .onAppear(perform: viewModel.fetchRadioStations)
            .navigationBarTitle("AVRadio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation {
                            viewModel.isFavoritesShowing.toggle()
                        }
                    } label: {
                        Image(systemName: viewModel.isFavoritesShowing ? "star.fill" : "star")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Select Region", selection: $viewModel.countryCode) {
                            ForEach(CountryCode.allCases, id: \.self) { country in
                                Text(country.displayText).tag(country)
                            }
                        }
                    } label: {
                        Image(systemName: "globe")
                    }
                    
                }
            }
        }
        .tint(keyColor)
        .onChange(of: viewModel.countryCode) { _ in
            viewModel.needUpdate = true
            viewModel.fetchRadioStations()
        }
    }
    
    // MARK: - List of Fetched or Favorites Radio Stations
    var radioList: some View {
        List(searchResults, id: \.id) { station in
            NavigationLink {
                PlayerView(radioStation: station)
            } label: {
                HStack {
                    AsyncImage(
                        url: URL(string: station.favicon),
                        transaction: Transaction(animation: .default)
                    ) {
                        switch $0 {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                        case .failure:
                            Image(systemName: "radio")
                                .resizable()
                                .padding(10)
                                .background(Color.accentColor)
                        @unknown default:
                            fatalError()
                        }
                    }
                    .frame(width: 50, height: 50)
                    .scaledToFit()
                    .cornerRadius(12)
                    
                    Text(station.name)
                    
                }
                .swipeActions(edge: .trailing) {
                    if !viewModel.isFavoritesShowing {
                        Button {
                            viewModel.addToFavorites(station: station)
                        } label: {
                            Image(systemName: "star")
                        }
                    }
                }
                .swipeActions(edge: .leading) {
                    if viewModel.isFavoritesShowing {
                        Button {
                            withAnimation {
                                viewModel.removeFromFavorites(station: station)
                            }
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: Text("Search by name")
        )
    }
}

extension RadioStationsView {
    var searchResults: [RadioStation] {
        let stations = viewModel.isFavoritesShowing
        ? viewModel.favoriteStations
        : viewModel.radioStations
        
        if searchText.isEmpty {
            return stations
        } else {
            return stations.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

// MARK: - Preview
struct RadioStations_Previews: PreviewProvider {
    static var previews: some View {
        RadioStationsView()
            .environmentObject(RadioStationsViewModel())
    }
}
