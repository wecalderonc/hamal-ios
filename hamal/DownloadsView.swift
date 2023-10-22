//
//  DownloadsView.swift
//  Hamal-ios
//
//  Created by Will on 21/10/23.
//

import SwiftUI

struct DownloadsView: View {
    @State private var downloadedFiles: [String] = ["Sample1.mp3", "Sample2.mp3"]
    
    var body: some View {
        List(downloadedFiles, id: \.self) { file in
            HStack {
                Text(file)
                Spacer()
                Button("Play") {
                    // Playback functionality is not handled in this mock
                }
            }
        }
        .padding()
    }
}


#Preview {
    DownloadsView()
}
