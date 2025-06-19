//
//  PhotosListApp.swift
//  PhotosList
//
//  Created by Sergey Kozlov on 17.06.2025.
//

import SwiftUI

@main
struct PhotosListApp: App {
    @StateObject var photosListViewModel = PhotosListViewModel()
    var body: some Scene {
        WindowGroup {
            PhotosListView(viewModel: PhotosListViewModel())
        }
    }
}
