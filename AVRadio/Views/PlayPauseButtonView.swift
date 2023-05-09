//
//  PlayPauseButtonView.swift
//  AVRadio
//
//  Created by Artemy Volkov on 09.05.2023.
//

import SwiftUI

struct PlayPauseButtonView: View {
    @Binding var isPlaying: Bool
    let size: CGFloat
    let action: () -> ()
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Image(systemName: "pause.fill")
                    .scaleEffect(isPlaying ? 1 : 0.01)
                    .opacity(isPlaying ? 1 : 0)
                
                Image(systemName: "play.fill")
                    .scaleEffect(isPlaying ? 0.01 : 1)
                    .opacity(isPlaying ? 0 : 1)
            }
            .shadow(radius: 5)
            .animation(.interpolatingSpring(stiffness: 175, damping: 15), value: isPlaying)
        }
        .font(.system(size: size))
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(Circle())
    }
}
