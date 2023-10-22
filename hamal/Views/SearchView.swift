//
//  SearchView.swift
//  Hamal-ios
//
//  Created by Will on 21/10/23.
//

import SwiftUI
import AVFoundation

struct SearchView: View {
    
    @State private var query: String = ""
    @State private var videoResults: [VideoResult] = []
    @ObservedObject var audioPlayerManager: AudioPlayerManager
    @State private var showPlayer: Bool = false
    
    var apiService = ApiService()
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Search for a video", text: $query)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            Button("Search") {
                apiService.searchYoutube(query: query) { results in
                    DispatchQueue.main.async {
                        if let results = results {
                            videoResults = results
                        } else {
                            // Handle error
                            print("Failed to decode the results or some other error.")
                        }
                    }
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            List(videoResults) { video in
                HStack {
                    Text(video.title)
                    Spacer()
                    if video.isDownloading {
                        ProgressView()  // Shows a loading animation
                    } else if video.isDownloaded || isSongDownloaded(title: video.title) {
                        Image(systemName: "play.circle.fill")  // Shows a play icon
                            .font(.system(size: 24))
                            .onTapGesture {
                                if let url = getLocalSongURL(title: video.title) {
                                    audioPlayerManager.loadAudio(from: url)
                                    audioPlayerManager.play()
                                    showPlayer = true
                                }
                            }
                    } else {
                        Button(action: {
                            downloadVideo(video: video)
                        }) {
                            Image(systemName: "arrow.down.circle")  // Shows the download icon
                                .font(.system(size: 24))
                        }
                    }
                }
            }
            Spacer() // Esto asegura que el reproductor se coloque en la parte inferior
            
//            if showPlayer {
//                PlayerView(audioPlayerManager: audioPlayerManager)
//                    .onChange(of: audioPlayerManager.songHasFinished, perform: { value in
//                        if value == true {
//                            showPlayer = false
//                            audioPlayerManager.songHasFinished = false  // Reset this after using it
//                        }
//                    })
//            }
            
        }
        .padding()
    }
    
    func downloadVideo(video: VideoResult) {
        guard !video.isDownloading, !video.isDownloaded else { return }
        // Update video state to downloading
        if let index = videoResults.firstIndex(where: { $0.id == video.id }) {
            videoResults[index].isDownloading = true
        }
        
        apiService.downloadVideo(requestBody: DownloadRequestBody(url: video.url, title: video.title)) { data in
            // Once download completes, update states accordingly
            if let index = self.videoResults.firstIndex(where: { $0.id == video.id }) {
                videoResults[index].isDownloading = false
                
                if let data = data {
                    videoResults[index].isDownloaded = true
                    saveToDisk(data: data, video: video)
                } else {
                    // Handle error
                    print("Error downloading video")
                }
            }
        }
    }
    
    func saveToDisk(data: Data, video: VideoResult) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let documentsDirectory = paths.first {
            let fileURL = documentsDirectory.appendingPathComponent(video.title).appendingPathExtension("mp3")
            do {
                try data.write(to: fileURL)
                print("Song saved at: \(fileURL)")
                if let index = videoResults.firstIndex(where: { $0.title == video.title }) {
                    videoResults[index].isDownloaded = true
                }
            } catch {
                // Handle the error
                print("Error saving song: \(error)")
            }
        }
    }
    
    func isSongDownloaded(title: String) -> Bool {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let documentsDirectory = paths.first {
            let fileURL = documentsDirectory.appendingPathComponent(title).appendingPathExtension("mp3")
            return FileManager.default.fileExists(atPath: fileURL.path)
        }
        return false
    }
    
    func getLocalSongURL(title: String) -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let documentsDirectory = paths.first {
            let fileURL = documentsDirectory.appendingPathComponent(title).appendingPathExtension("mp3")
            if FileManager.default.fileExists(atPath: fileURL.path) {
                return fileURL
            }
        }
        return nil
    }
    
}


//#Preview {
//    SearchView()
//}
