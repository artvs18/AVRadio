//
//  AudioWaveVisualiserView.swift
//  AVRadio
//
//  Created by Artemy Volkov on 07.05.2023.
//

import SwiftUI

struct AudioWaveVisualiserView: View {
    @Binding var isPlaying: Bool
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<6) { _ in
                RoundedRectangle(cornerRadius: 3)
                    .frame(
                        width: 3,
                        height: isAnimating ? .random(in: 5...25) : 3
                    )
                    .foregroundColor(.accentColor)
            }
            .animation(.easeInOut(duration: 0.25), value: isAnimating)
        }
        .frame(height: 50)
        .onAppear(perform: startTimer)
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 0.24, repeats: true) { _ in
            if isPlaying {
                isAnimating.toggle()
            } else {
                isAnimating = false
            }
        }
    }
}
