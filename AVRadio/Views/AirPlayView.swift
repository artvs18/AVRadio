//
//  AirPlayView.swift
//  AVRadio
//
//  Created by Artemy Volkov on 05.05.2023.
//

import SwiftUI
import AVKit

struct AirPlayView: View {
    var body: some View {
        AirPlayViewRepresentable()
    }
}

struct AirPlayViewRepresentable: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: Context) { }
    
    func makeUIView(context: Context) -> UIView {
        let routePickerView = AVRoutePickerView()
        routePickerView.backgroundColor = .clear
        routePickerView.activeTintColor = .label
        
        return routePickerView
    }
}
