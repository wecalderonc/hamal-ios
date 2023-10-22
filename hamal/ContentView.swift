//
//  ContentView.swift
//  Hamal-ios
//
//  Created by Will on 21/10/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            TabView {
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                
                DownloadsView()
                    .tabItem {
                        Label("Downloads", systemImage: "arrow.down.circle")
                    }
            }
        }
}

#Preview {
    ContentView()
}
