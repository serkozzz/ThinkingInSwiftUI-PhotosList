//
//  Server.swift
//  PhotosList
//
//  Created by Sergey Kozlov on 17.06.2025.
//

import SwiftUI

class Server {
    static var shared = Server()
    private init() {}
    
    private let listUrl =  "https://picsum.photos/v2/list"
    
    private var photosCache = ImageCache()
    
    private var tasksQueue: [String: Task<UIImage, Error>] = [:]
    
    @MainActor
    private func addTaskToQueue(url:String, task: Task<UIImage, Error>) { tasksQueue[url] = task }
    
    @MainActor
    private func removeTaskFromQueue(url:String) { tasksQueue.removeValue(forKey: url) }

    func photosList() async throws -> [PhotoMetadata] {
        
        let url = URL(string: listUrl)!
        let responseString = try await requestJson(url: url)
        
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

    func photo(urlStr: String) async throws -> UIImage {
        if let cachedImage = await photosCache.get(for: urlStr) {
            return cachedImage
        }
        
        if let task = tasksQueue[urlStr] {
            return try await task.value
        }
        
        let task = Task {
            let image = try await requestImage(url: URL(string: urlStr)!)
            await removeTaskFromQueue(url: urlStr)
            await photosCache.set(image, for: urlStr)
            return image
        }
        
        await addTaskToQueue(url: urlStr, task: task)
        return try await task.value
    }
    
    @MainActor
    func cancelPhotoRequest(urlStr: String)  {
        tasksQueue[urlStr]?.cancel()
        removeTaskFromQueue(url: urlStr)
    }
    
    private func requestJson(url: URL) async throws -> String {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
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
    
    private func requestImage(url: URL) async throws -> UIImage {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await urlSession().data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("📡 Status code: \(httpResponse.statusCode)")
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            print(String(data: data, encoding: .utf8) ?? "")
            throw URLError(.badServerResponse)
        }
        
        guard let image = UIImage(data: data) else {
            print("❌ Failed to convert data to UIImage.")
            throw URLError(.cannotDecodeContentData)
        }
        return image
    }
    
    
    func urlSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 360  // ⏱ Время на установку соединения
        config.timeoutIntervalForResource = 360 // ⏱ Общее время на запрос

        let session = URLSession(configuration: config)
        return session
    }
}

