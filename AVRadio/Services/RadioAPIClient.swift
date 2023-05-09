//
//  RadioAPIClient.swift
//  AVRadio
//
//  Created by Artemy Volkov on 09.05.2023.
//

import Foundation
import Combine

class RadioBrowserAPIClient {
    private let baseURL = "http://de1.api.radio-browser.info/json/"
    
    func fetchStationsByCountryCode(_ countryCode: String) -> AnyPublisher<[RadioStation], Error> {
        let endpoint = "stations/bycountrycodeexact/\(countryCode)"
        guard let url = URL(string: baseURL + endpoint) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [RadioStation].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
