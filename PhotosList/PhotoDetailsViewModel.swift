//
//  PhotoDetailsViewModel.swift
//  PhotosList
//
//  Created by Sergey Kozlov on 19.06.2025.
//

import SwiftUI

@MainActor
class PhotoDetailsViewModel: ObservableObject {
    
    var url: String
    @Published var isLoading = true
    @Published var image: UIImage?
    @Published var error: IdentifiableError?
    
    init(url: String) {
        self.url = url
    }
    
    func loadPhoto() async {
        isLoading = true
        do {
            image = try await Server().photo(urlStr: url)
            isLoading = false
        }
        catch (let err){
            error = IdentifiableError(error: err)
            isLoading = false
        }
    }
}
