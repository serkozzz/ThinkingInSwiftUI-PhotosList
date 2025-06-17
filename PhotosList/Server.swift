//
//  Server.swift
//  PhotosList
//
//  Created by Sergey Kozlov on 17.06.2025.
//

import Foundation

class Server {
    private let listUrl =  "https://picsum.photos/v2/list"
    
    func photosList() async throws -> [PhotoMetadata] {
        
        let url = URL(string: listUrl)!
        let responseString = try await getRequestForJson(url: url)
        
        let jsonData = responseString.data(using: .utf8)!
        
        do {
            let contentResponse = try JSONDecoder().decode([PhotoMetadata].self, from: jsonData)
            return contentResponse
        } catch {
            throw NSError(domain: "PhotoListDecoding", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Failed to parse response: \(error)"
            ])
        }
    }
    
    private func getRequestForJson(url: URL) async throws -> String {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await urlSession().data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("📡 Status code: \(httpResponse.statusCode)")
            print("📦 Response: \(String(data: data, encoding: .utf8) ?? "nil")")
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            print(String(data: data, encoding: .utf8) ?? "")
            throw URLError(.badServerResponse)
        }
        
        guard let responseString = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        return responseString
    }
    
    
    func urlSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 360  // ⏱ Время на установку соединения
        config.timeoutIntervalForResource = 360 // ⏱ Общее время на запрос

        let session = URLSession(configuration: config)
        return session
    }
}

