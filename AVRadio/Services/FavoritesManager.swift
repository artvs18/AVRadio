//
//  FavoritesManager.swift
//  AVRadio
//
//  Created by Artemy Volkov on 10.05.2023.
//

import Foundation

class FavoritesManager {
    private let key = "favoriteStations"
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func save(favoriteStations: [RadioStation]) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(favoriteStations) {
            userDefaults.set(encodedData, forKey: key)
        }
    }
    
    func load() -> [RadioStation] {
        let decoder = JSONDecoder()
        if let data = userDefaults.data(forKey: key),
           let decodedStations = try? decoder.decode([RadioStation].self, from: data) {
            return decodedStations
        }
        return []
    }
}
