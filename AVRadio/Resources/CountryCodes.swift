//
//  CountryCodes.swift
//  AVRadio
//
//  Created by Artemy Volkov on 10.05.2023.
//

// MARK: - Country Codes
enum CountryCode: String, CaseIterable {
    case ru = "RU"
    case us = "US"
    case gb = "GB"
    case de = "DE"
    case fr = "FR"
    case tr = "TR"
    case es = "ES"
    case pl = "PL"
    case mx = "MX"
    case kr = "KR"
    case jp = "JP"
    case it = "IT"
    case `in` = "IN"
    case fi = "FI"
    case cz = "CZ"
    case cn = "CN"
    case ca = "CA"
    
    var displayText: String {
        switch self {
        case .ru:
            return "Russia"
        case .us:
            return "United States"
        case .gb:
            return "United Kingdom"
        case .de:
            return "Deutschland"
        case .fr:
            return "France"
        case .tr:
            return "Turkey"
        case .es:
            return "Spain"
        case .pl:
            return "Poland"
        case .mx:
            return "Mexico"
        case .kr:
            return "Korea"
        case .jp:
            return "Japan"
        case .it:
            return "Italy"
        case .in:
            return "India"
        case .fi:
            return "Finland"
        case .cz:
            return "Czech Republic"
        case .cn:
            return "China"
        case .ca:
            return "Canada"
        }
    }
}
