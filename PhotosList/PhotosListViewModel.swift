//
//  PhotosListViewModel.swift
//  PhotosList
//
//  Created by Sergey Kozlov on 17.06.2025.
//

import SwiftUI

@MainActor
class PhotosListViewModel: ObservableObject {
    @Published var isLoading: Bool
    @Published var error: IdentifiableError?
    
    @Published var photos: [PhotoMetadata] = []
    
    init() {
        isLoading = true
        Task() {
            do {
                self.photos = try await Server().photosList()
                isLoading = false
            }
            catch (let error) {
                self.error = IdentifiableError(error: error)
                isLoading = false
            }
        }
    }
}
