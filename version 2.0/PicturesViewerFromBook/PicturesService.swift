//
//  PicturesService.swift
//  PicturesViewerFromBook
//
//  Created by Sergey Kozlov on 23.09.2026.
//

import SwiftUI

@MainActor
class PicturesService {
    private let serverAPI = ServerAPI()
    
    private var picturesList: [PictureDTO]?
    
    private var iconsCache: [String: UIImage] = [:]
    private var picturesCache: [String: UIImage] = [:]
    
    func getPicturesList() async throws -> [PictureDTO] {
        if picturesList == nil {
            picturesList = try await serverAPI.getPicturesList()
        }
        return picturesList!
    }
    
    func getIcon(for picture: PictureDTO) async throws -> UIImage {
        if iconsCache[picture.id] == nil {
            iconsCache[picture.id] = try await serverAPI.getPicture(url: picture.download_url)
        }
        return iconsCache[picture.id]!
    }
}
