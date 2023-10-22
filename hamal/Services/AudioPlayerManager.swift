//
//  AudioPlayerManager.swift
//  hamal
//
//  Created by Will on 22/10/23.
//
import AVFoundation

class AudioPlayerManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    var audioPlayer: AVAudioPlayer?
    private var audioURL: URL?
    @Published var isPlaying: Bool = false
    @Published var songHasFinished: Bool = false
    @Published var audioSourceChanged: Bool = false
    
    func loadAudio(from url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioSourceChanged.toggle()  // Notify that the source changed
        } catch {
            print("Error loading audio: \(error)")
        }
    }
    
    func play() {
        if let player = audioPlayer, !player.isPlaying {
            player.play()
            isPlaying = true
        }
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        songHasFinished = true
    }
    
    var duration: TimeInterval {
        return audioPlayer?.duration ?? 0
    }
    
    var currentTime: TimeInterval {
        return audioPlayer?.currentTime ?? 0
    }
    
    func setCurrentTime(to time: TimeInterval) {
        audioPlayer?.currentTime = time
    }
}

