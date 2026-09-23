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
                                CellView(photo: photo)
                                .frame(height: 100)
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

private struct CellView: View {
    
    @State var image: UIImage?
    private let photo: PhotoMetadata
    
    init(photo: PhotoMetadata) {
        self.photo = photo
    }
    
    var body: some View {
        HStack {
            Text(photo.author)
            Spacer()
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            else {
                ProgressView()
            }
        }
        .onAppear {
            Task {
                image = try? await Server.shared.photo(urlStr: photo.download_url)
            }
        }
        .onDisappear {
            Server.shared.cancelPhotoRequest(urlStr: photo.download_url)
        }
    }
}

#Preview {
    @Previewable @StateObject var photosVM = PhotosListViewModel()
    PhotosListView(viewModel: photosVM)
}

