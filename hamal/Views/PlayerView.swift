//
//  PlayerView.swift
//  hamal
//
//  Created by Will on 22/10/23.
//

import SwiftUI
import AVFoundation

struct PlayerView: View {
    @State private var playbackPosition: TimeInterval = 0
    @State private var songDuration: TimeInterval = 0
    @State private var updateTimer: Timer? = nil
    @ObservedObject var audioPlayerManager: AudioPlayerManager
    
    var body: some View {
        VStack {
            HStack {
                Text("\(Int(playbackPosition))s")
                Slider(value: $playbackPosition, in: 0...songDuration, onEditingChanged: sliderEditingChanged)
                Text("\(Int(songDuration))s")
            }
            .padding(.horizontal)
            
            Button(action: {
                self.togglePlayback()
            }) {
                Image(systemName: audioPlayerManager.isPlaying == true ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
        }
        .onAppear {
            songDuration = audioPlayerManager.duration
            
            // Update the slider every second
            self.updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                playbackPosition = audioPlayerManager.currentTime
            }
        }
        .onReceive(audioPlayerManager.$audioSourceChanged) { _ in
            songDuration = audioPlayerManager.duration
        }
        .onDisappear {
            self.updateTimer?.invalidate()
            self.updateTimer = nil
        }
    }
    
    func togglePlayback() {
        if audioPlayerManager.isPlaying {
            audioPlayerManager.pause()
        } else {
            audioPlayerManager.play()
        }
    }
    
    func sliderEditingChanged(editingStarted: Bool) {
        if editingStarted {
            // Pause the audio and stop updating the slider
            audioPlayerManager.pause()
            updateTimer?.invalidate()
        } else {
            // User finished dragging the slider, so update the audio's current time and resume playback
            audioPlayerManager.setCurrentTime(to: playbackPosition)
            audioPlayerManager.play()
            updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                playbackPosition = audioPlayerManager.currentTime
            }
        }
    }
}
