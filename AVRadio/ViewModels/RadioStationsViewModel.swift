//
//  RadioStationsViewModel.swift
//  AVRadio
//
//  Created by Artemy Volkov on 09.05.2023.
//

import Foundation
import Combine
import SwiftUI

class RadioStationsViewModel: ObservableObject {
    @AppStorage("selectedCountryCode") private var storedCountryCode: String = CountryCode.ru.rawValue
    @Published private(set) var radioStations: [RadioStation] = []
    @Published private(set) var favoriteStations: [RadioStation] = []
    @Published private(set) var isLoading = true
    
    @Published var needUpdate = true
    
    
    @Published var countryCode: CountryCode = .ru {
        didSet {
            storedCountryCode = countryCode.rawValue
        }
    }
    
    @Published var isFavoritesShowing = false {
        didSet {
            if isFavoritesShowing {
                fetchFavoriteStations()
            }
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    private let apiClient: RadioAPIClient
    private let favoritesManager: FavoritesManager
    
    init(apiClient: RadioAPIClient = RadioAPIClient()) {
        self.apiClient = apiClient
        self.favoritesManager = FavoritesManager()
        if let initialCountryCode = CountryCode(rawValue: storedCountryCode) {
            self.countryCode = initialCountryCode
        }
        fetchFavoriteStations()
    }
    
    // MARK: - Fetch Radio Stations from Server
    func fetchRadioStations() {
        guard needUpdate else { return }
        isLoading = true
        
        apiClient.fetchStationsByCountryCode(countryCode.rawValue)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching radio stations: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] stations in
                let filteredStations = stations.filter { station in
                    return !station.name.isEmpty &&
                    !station.url.isEmpty &&
                    station.url.hasPrefix("https") &&
                    !station.favicon.isEmpty &&
                    station.favicon.hasPrefix("https")
                }
                self?.radioStations = filteredStations
                self?.isLoading = false
                self?.needUpdate = false
            })
            .store(in: &cancellables)
    }
}

// MARK: - Favorite Stations Methods
extension RadioStationsViewModel {
    private func fetchFavoriteStations() {
        favoriteStations = favoritesManager.load()
    }
    
    func addToFavorites(station: RadioStation) {
        if !favoriteStations.contains(where: { $0.url == station.url }) {
            favoriteStations.append(station)
            favoritesManager.save(favoriteStations: favoriteStations)
        }
    }

    func removeFromFavorites(station: RadioStation) {
        favoriteStations.removeAll { $0.url == station.url }
        favoritesManager.save(favoriteStations: favoriteStations)
    }
}
