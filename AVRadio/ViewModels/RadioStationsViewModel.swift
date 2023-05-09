//
//  RadioStationsViewModel.swift
//  AVRadio
//
//  Created by Artemy Volkov on 09.05.2023.
//

import Foundation
import Combine

class RadioStationsViewModel: ObservableObject {
    @Published private(set) var radioStations: [RadioStation] = []
    private var cancellables: Set<AnyCancellable> = []
    private let apiClient: RadioBrowserAPIClient
    
    init(apiClient: RadioBrowserAPIClient = RadioBrowserAPIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchRadioStations(countryCode: String) {
        apiClient.fetchStationsByCountryCode(countryCode)
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
            })
            .store(in: &cancellables)
    }
}
