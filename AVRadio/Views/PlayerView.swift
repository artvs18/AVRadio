//
//  PlayerView.swift
//  AVRadio
//
//  Created by Artemy Volkov on 05.05.2023.
//

import SwiftUI

struct PlayerView: View {
    @AppStorage("keyColor") var keyColor = Color.primary
    @ObservedObject private var viewModel = PlayerViewModel.shared
    
    @State private var isVisualising = false
    @State private var isPlaying = false
    
    let radioStation: RadioStation
    
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    private var isPortrait: Bool {
        verticalSizeClass == .regular
    }
    
    var body: some View {
        ZStack {
            VisualiserView(isPlaying: $isPlaying, isVisualising: $isVisualising)
                .ignoresSafeArea()
            
            if isPortrait {
                VStack {
                    Spacer()
                    
                    PlayPauseButtonView(
                        isPlaying: $isPlaying,
                        size: 65,
                        action: toggleStream
                    )
                    .padding()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                AudioWaveVisualiserView(isPlaying: $isPlaying)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                ColorPicker("", selection: $keyColor, supportsOpacity: false)
            }
            
            ToolbarItem(placement: .bottomBar) {
                ShareLink(item: URL(string: radioStation.url)!) {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .scaledToFill()
                        .padding()
                        .frame(width: 50, height: 50)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
            }
            
            ToolbarItem(placement: .status) {
                Toggle("Visualiser", isOn: $isVisualising)
                    .frame(height: 50)
                    .padding(.horizontal)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .toggleStyle(.switch)
                
            }
            
            ToolbarItem(placement: .bottomBar) {
                if !isPortrait {
                    PlayPauseButtonView(
                        isPlaying: $isPlaying,
                        size: 35,
                        action: toggleStream
                    )
                    .padding()
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                AirPlayView()
                    .frame(width: 50, height: 50)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(radioStation.name)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
    }
    
    private func toggleStream() {
        isPlaying.toggle()
        isPlaying ? viewModel.play(radioStation) : viewModel.pause()
    }
}
