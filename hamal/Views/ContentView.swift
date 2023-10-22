//
//  ContentView.swift
//  Hamal-ios
//
//  Created by Will on 21/10/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var audioPlayerManager = AudioPlayerManager()
    
    var body: some View {
        VStack(spacing: 0) {
            // Display PlayerView conditionally
            if audioPlayerManager.isPlaying || audioPlayerManager.currentTime > 0 {
                PlayerView(audioPlayerManager: audioPlayerManager)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                Divider()
            }
            
            TabView {
                SearchView(audioPlayerManager: audioPlayerManager)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                
                DownloadsView(audioPlayerManager: audioPlayerManager)
                    .tabItem {
                        Label("Downloads", systemImage: "arrow.down.circle")
                    }
            }
        }
    }
}


#Preview {
    ContentView()
}
