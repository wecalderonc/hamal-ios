//
//  ApiService.swift
//  Hamal-ios
//
//  Created by Will on 21/10/23.
//

import Foundation

class ApiService {
    private let baseURL = "http://localhost:3000/"
    
    func searchYoutube(query: String, completion: @escaping ([VideoResult]?) -> ()) {
        guard let url = URL(string: baseURL + "youtube_search/search?query=\(query)") else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let videoResults = try decoder.decode([VideoResult].self, from: data)
                completion(videoResults)
            } catch {
                print("Decoding error: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    func downloadVideo(requestBody: DownloadRequestBody, completion: @escaping (Data?) -> ()) {
        guard let url = URL(string: baseURL + "downloads") else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(requestBody)

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            completion(data)
        }.resume()
    }
}
