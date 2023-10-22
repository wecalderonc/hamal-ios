//
//  SearchView.swift
//  Hamal-ios
//
//  Created by Will on 21/10/23.
//

import SwiftUI

struct SearchView: View {
    @State private var query: String = ""
    @State private var videoResults: [VideoResult] = []
    
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
                    } else if video.isDownloaded {
                        Image(systemName: "play.circle.fill")  // Shows a play icon
                            .font(.system(size: 24))
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
                    saveToDisk(data: data, title: video.title)
                } else {
                    // Handle error
                    print("Error downloading video")
                }
            }
        }
    }

    func saveToDisk(data: Data, title: String) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let documentsDirectory = paths.first {
            let fileURL = documentsDirectory.appendingPathComponent(title).appendingPathExtension("mp3") // Change "mp4" to the correct file format if different
            do {
                try data.write(to: fileURL)
                print("Video saved at: \(fileURL)")
            } catch {
                // Handle the error
                print("Error saving video: \(error)")
            }
        }
    }
    
}



#Preview {
    SearchView()
}
