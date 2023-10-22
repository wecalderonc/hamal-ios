//
//  VideoResult.swift
//  Hamal-ios
//
//  Created by Will on 21/10/23.
//

import Foundation

struct VideoResult: Identifiable {
    var id  = UUID()
    var title: String
    var url: String
    var isDownloading: Bool = false
    var isDownloaded: Bool = false
    var localPath: URL?
}

extension VideoResult: Codable {
    enum CodingKeys: String, CodingKey {
        case title, url
    }
}
