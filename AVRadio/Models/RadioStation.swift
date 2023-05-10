//
//  RadioStation.swift
//  AVRadio
//
//  Created by Artemy Volkov on 09.05.2023.
//

import Foundation

struct RadioStation: Codable {
    let id = UUID()
    let name: String
    let url: String
    let favicon: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
        case favicon
    }
}
