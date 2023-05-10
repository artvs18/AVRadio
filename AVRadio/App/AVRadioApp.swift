//
//  AVRadioApp.swift
//  AVRadio
//
//  Created by Artemy Volkov on 05.05.2023.
//

import SwiftUI

@main
struct AVRadioApp: App {
    let radioStationsViewModel = RadioStationsViewModel()

    var body: some Scene {
        WindowGroup {
            RadioStationsView()
                .environmentObject(radioStationsViewModel)
        }
    }
}
