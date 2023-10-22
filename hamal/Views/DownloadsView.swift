//
//  DownloadsView.swift
//  Hamal-ios
//
//  Created by Will on 21/10/23.
//

import SwiftUI

struct DownloadsView: View {
    @State private var downloadedFiles: [String] = []
    @State private var selectedFile: String? = nil
    @ObservedObject var audioPlayerManager: AudioPlayerManager
    
    var body: some View {
        VStack(spacing: 0) {
            List(downloadedFiles, id: \.self) { file in
                HStack {
                    Text(file)
                    Spacer()
                    Button(action: {
                        self.selectedFile = file
                        self.loadAndPlay(file: file)
                    }) {
                        Image(systemName: audioPlayerManager.isPlaying && selectedFile == file ? "pause.circle.fill" : "play.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                }
            }
            .padding(.top)
            
//            Divider()
            
//            if let playingFile = selectedFile {
//                PlayerView(audioPlayerManager: audioPlayerManager)
//                    .padding()
//                    .background(Color.gray.opacity(0.1))
//            }
        }
        .onAppear {
            downloadedFiles = fetchDownloadedSongs()
        }
    }
    
    func loadAndPlay(file: String) {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(file)
        
        audioPlayerManager.loadAudio(from: fileURL)
        audioPlayerManager.play()
    }
    
    func fetchDownloadedSongs() -> [String] {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            // Filter and return only .mp3 files or any other audio format you're using
            return fileURLs.filter { $0.pathExtension == "mp3" }.map { $0.lastPathComponent }
            
        } catch {
            print("Error fetching files: \(error)")
            return []
        }
    }
}
