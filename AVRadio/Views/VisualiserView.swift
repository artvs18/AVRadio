//
//  WavyAnimation.swift
//  AVRadio
//
//  Created by Artemy Volkov on 05.05.2023.
//

import SwiftUI

struct VisualiserView: View {
    @Binding var isPlaying: Bool
    @Binding var isVisualising: Bool
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            RadialGradient(
                colors: [.clear, .clear, .clear, .accentColor, .clear, .clear, .clear],
                center: .center,
                startRadius: 0,
                endRadius: isAnimating ? .random(in: 1500...2500) : 0
            )
            .animation(.linear(duration: 5).repeatCount(isAnimating ? .max : 0, autoreverses: true), value: isAnimating)
            
            ForEach(0..<10) { index in
                Circle()
                    .stroke(lineWidth: 1)
                    .frame(width: CGFloat(index * 25), height: CGFloat(index * 25))
                    .foregroundColor(.accentColor)
                    .shadow(color: .accentColor, radius: 1)
                    .rotation3DEffect(
                        .degrees(isAnimating ? 360 : 0),
                        axis:(
                            x: isAnimating ? .random(in: 0...360) : 0,
                            y: isAnimating ? .random(in: 0...360) : 0,
                            z: isAnimating ? .random(in: 0...360) : 0
                        ),
                        anchor: .center, anchorZ: 15, perspective: 2
                    )
                    .animation(.easeInOut(duration: isAnimating ? .random(in: 2.5...10) : 5), value: isAnimating)
                
            }
            .onAppear(perform: startTimer)
        }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { _ in
            if isPlaying && isVisualising {
                isAnimating.toggle()
            } else {
                isAnimating = false
            }
        }
    }
}
