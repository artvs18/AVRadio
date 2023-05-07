//
//  PlayerManager.swift
//  AVRadio
//
//  Created by Artemy Volkov on 05.05.2023.
//

import Foundation
import AVFoundation


enum API: String {
    case url = "https://0n-smoothjazz.radionetz.de/0n-smoothjazz.aac"
}

class PLayerManager {
    static let shared = PLayerManager()
    private var player = AVPlayer()
    
    
    private init() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback,
                                         mode: .default,
                                         policy: .longFormAudio)
        } catch {
            print("Cannot use airplay")
        }
    }
    
    func play() {
        do {
            try AVAudioSession
                .sharedInstance()
                .setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is active")
        } catch {
            print("error")
        }
        
        player = AVPlayer(url: URL(string: API.url.rawValue)!)
        player.allowsExternalPlayback = true
        player.appliesMediaSelectionCriteriaAutomatically = true
        player.automaticallyWaitsToMinimizeStalling = true
        player.volume = 1
        player.play()
        
        
    }
    
    func pause() {
        player.pause()
    }
    
}
