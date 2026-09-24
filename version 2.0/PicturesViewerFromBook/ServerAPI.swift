//
//  ServerAPI.swift
//  PicturesViewerFromBook
//
//  Created by Sergey Kozlov on 22.09.2026.
//

import SwiftUI


class ServerAPI {
    let endpoint = URL(string: "https://picsum.photos/v2/list")!
    
    func getPicturesList() async throws -> [PictureDTO] {
        let data = try await sendGetRequest(endpoint)
        do {
            return try JSONDecoder().decode([PictureDTO].self, from: data)
        }
        catch {
            throw ServerAPIError.invalidJSON
        }
    }
    
    func getPicture(url: String) async throws -> UIImage {
        guard let url = URL(string: url) else {
            throw ServerAPIError.invalidURL
        }
        let data = try await sendGetRequest(url)
        guard let image = UIImage(data: data) else {
            throw ServerAPIError.invalidImageData
        }
        return image
    }
    
    private func sendGetRequest(_ url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw ServerAPIError.unknown
            }
            try Task.checkCancellation()

            guard (200..<300).contains(response.statusCode) else {
                throw ServerAPIError.from(
                    statusCode: response.statusCode
                )
            }
            return data
        }
        catch is CancellationError {
            throw ServerAPIError.cancellation
        } catch let error as URLError where error.code == .cancelled {
            throw ServerAPIError.cancellation
        }
        catch let error as ServerAPIError{
            throw error
        }
        catch let error as URLError {
            throw ServerAPIError(urlError: error)
        } catch {
            throw ServerAPIError.unknown
        }
        
        
    }
}

