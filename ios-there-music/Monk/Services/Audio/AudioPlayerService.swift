import AVFoundation
import Combine
import Foundation

@MainActor
final class AudioPlayerService: ObservableObject {
    @Published private(set) var state: PlaybackState = .idle
    @Published private(set) var currentTime: Double = 0
    @Published private(set) var duration: Double = 30
    @Published var volume: Float = 0.8 { didSet { player?.volume = volume } }

    private var player: AVPlayer?
    private var timeObserver: Any?

    func play(track: Track) {
        guard let url = track.previewURL else { return }
        removeObserver()
        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        player?.volume = volume
        duration = Double(max(track.durationMillis, 30_000)) / 1000
        addObserver()
        player?.play()
        state = .playing
    }

    func toggle() {
        if state == .playing {
            player?.pause()
            state = .paused
        } else {
            player?.play()
            state = .playing
        }
    }

    func seek(to value: Double) {
        player?.seek(to: CMTime(seconds: value, preferredTimescale: 600))
        currentTime = value
    }

    private func addObserver() {
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { [weak self] time in
            Task { @MainActor in self?.currentTime = time.seconds.isFinite ? time.seconds : 0 }
        }
    }

    private func removeObserver() {
        if let timeObserver, let player { player.removeTimeObserver(timeObserver) }
        timeObserver = nil
    }
}

struct AudioSessionManager {
    func configure() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
}

final class AVPlayerDelegate: NSObject {}
