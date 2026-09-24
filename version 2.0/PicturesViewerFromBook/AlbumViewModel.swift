//
//  PicturesViewModel.swift
//  PicturesViewerFromBook
//
//  Created by Sergey Kozlov on 23.09.2026.
//

import SwiftUI
import Combine

@MainActor
class AlbumViewModel: ObservableObject {
    @Published var items: [AlbumItemViewModel] = []
    @Published var errorMessage: ServerAPIError?
    
    private var picturesService = PicturesService()
    
    func load() async {
        do {
            items = try await picturesService.getPicturesList().map {
                AlbumItemViewModel(dto: $0, picturesServise: picturesService)
            }
        }
        catch let error as ServerAPIError {
            errorMessage = error
        }
        catch {
            errorMessage = .unknown
        }
    }
}

@MainActor
class AlbumItemViewModel: ObservableObject, Identifiable {
    @Published var icon: UIImage?
    @Published var picture: UIImage?
    @Published var error: ServerAPIError?
    
    private var dto: PictureDTO
    private var picturesService = PicturesService()
    
    var id: String {
        dto.id
    }
    
    init(icon: UIImage? = nil, picture: UIImage? = nil, dto: PictureDTO, picturesServise: PicturesService) {
        self.icon = icon
        self.picture = picture
        self.dto = dto
        self.picturesService = picturesServise
    }
    
    var name: String {
        dto.id
    }
    
    func loadImage() async {
        
        do {
            self.icon = try await picturesService.getIcon(for: dto)
        }
        catch  {
            self.error = error as? ServerAPIError ?? .unknown
        }
    }
}
