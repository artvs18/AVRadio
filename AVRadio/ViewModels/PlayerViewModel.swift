//
//  PlayerViewModel.swift
//  AVRadio
//
//  Created by Artemy Volkov on 08.05.2023.
//

import AVFoundation
import MediaPlayer
import Combine

class PlayerViewModel: ObservableObject {
    
    static let shared = PlayerViewModel()

    private var player: AVPlayer
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        player = AVPlayer()
        setupAudioSession()
        setupRemoteCommandCenter()
    }
    
    // MARK: - Play
    func play(_ radioStation: RadioStation) {
        guard let url = URL(string: radioStation.url) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.allowsExternalPlayback = true
        player.appliesMediaSelectionCriteriaAutomatically = true
        player.automaticallyWaitsToMinimizeStalling = true
        player.volume = 1
        player.play()
        
        setupNowPlayingInfoCenter(for: radioStation)
    }
    
    // MARK: - Pause
    func pause() {
        player.pause()
    }
    
    // MARK: - Audio session setup
    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback,
                                         mode: .default,
                                         policy: .longFormAudio)
            try audioSession.setActive(true)
        } catch {
            print("Cannot play")
        }
    }
    
    // MARK: - Info center setup
    private func setupNowPlayingInfoCenter(for radioStation: RadioStation) {
        var nowPlayingInfo: [String: Any] = [:]

        nowPlayingInfo[MPMediaItemPropertyTitle] = radioStation.name

        if let artworkUrl = URL(string: radioStation.favicon) {
            let defaultImage = UIImage(named: "AppIcon")

            loadArtwork(from: artworkUrl, defaultImage: defaultImage)
                .sink { [weak self] artwork in
                    if let artwork = artwork {
                        nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
                    }

                    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
                    self?.cancellables.removeFirst()
                }
                .store(in: &cancellables)
        } else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
    }

    // MARK: - Remote command center setup
    private func setupRemoteCommandCenter() {
        let remoteCommandCenter = MPRemoteCommandCenter.shared()
        
        // Play command
        remoteCommandCenter.playCommand.isEnabled = true
        remoteCommandCenter.playCommand.addTarget { [unowned self] _ in
            self.player.play()
            return .success
        }
        
        // Pause command
        remoteCommandCenter.pauseCommand.isEnabled = true
        remoteCommandCenter.pauseCommand.addTarget { [unowned self] _ in
            self.player.pause()
            return .success
        }
        
        // Disabling all unnecessary commands
        remoteCommandCenter.nextTrackCommand.isEnabled = false
        remoteCommandCenter.previousTrackCommand.isEnabled = false
        remoteCommandCenter.seekForwardCommand.isEnabled = false
        remoteCommandCenter.seekBackwardCommand.isEnabled = false
        remoteCommandCenter.changePlaybackPositionCommand.isEnabled = false
    }
}

// MARK: - Artwork Handler
extension PlayerViewModel {
    private func downloadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func loadArtwork(from url: URL, defaultImage: UIImage? = nil) -> AnyPublisher<MPMediaItemArtwork?, Never> {
        downloadImage(from: url)
            .map { image in
                image ?? defaultImage
            }
            .map { image -> MPMediaItemArtwork? in
                guard let image = image else { return nil }
                let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in
                    return image
                }
                return artwork
            }
            .eraseToAnyPublisher()
    }
}
