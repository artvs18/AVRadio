//
//  PlayerView.swift
//  AVRadio
//
//  Created by Artemy Volkov on 05.05.2023.
//

import SwiftUI

struct PlayerView: View {
    @State private var isPlaying = false
    
    var body: some View {
        ZStack {
            WavyAnimation(isPlaying: $isPlaying)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Button(action: toggleStream) {
                    ZStack {
                        Image(systemName: "pause.fill")
                            .scaleEffect(isPlaying ? 1 : 0)
                            .opacity(isPlaying ? 1 : 0)
                        
                        Image(systemName: "play.fill")
                            .scaleEffect(isPlaying ? 0 : 1)
                            .opacity(isPlaying ? 0 : 1)
                    }
                    .font(.system(size: 65))
                    .shadow(radius: 5)
                    .animation(.interpolatingSpring(stiffness: 175, damping: 15), value: isPlaying)
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "gearshape")
                }
            }
            
            ToolbarItem(placement: .status) {
                AudioVisualizer(isPlaying: $isPlaying)
                    .frame(width: 100)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            
            ToolbarItem(placement: .bottomBar) {
                Button {
                    
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                .frame(width: 50, height: 50)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
            }
            
            ToolbarItem(placement: .bottomBar) {
                AirPlayView()
                    .frame(width: 50, height: 50)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("AVRadio")
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
    }
    
    private func toggleStream() {
        isPlaying.toggle()
        
        isPlaying ? PLayerManager.shared.play() : PLayerManager.shared.pause()
    }
    
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
            .preferredColorScheme(.dark)
    }
}
