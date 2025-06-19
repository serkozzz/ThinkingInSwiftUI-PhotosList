//
//  ContentView.swift
//  PhotosList
//
//  Created by Sergey Kozlov on 17.06.2025.
//

import SwiftUI

struct PhotosListView: View {
    
    @ObservedObject var viewModel: PhotosListViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if (viewModel.isLoading) {
                    ProgressView("Loading...")
                        .scaleEffect(1.5)
                }
                else {
                    List() {
                        ForEach(viewModel.photos) { photo in
                            NavigationLink {
                                PhotoDetailsView(urlStr: photo.download_url)
                            } label: {
                                Text(photo.author)
                            }
                        }
                    }
                    .padding()
                }
            }
            .alert(item: $viewModel.error) { err in
                Alert(title: Text("Error"), message: Text(err.message), dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Photos")
        }
        
    }
}

#Preview {
    @Previewable @StateObject var photosVM = PhotosListViewModel()
    PhotosListView(viewModel: photosVM)
}
