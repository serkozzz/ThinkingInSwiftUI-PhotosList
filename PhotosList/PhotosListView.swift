//
//  ContentView.swift
//  PhotosList
//
//  Created by Sergey Kozlov on 17.06.2025.
//

import SwiftUI

struct PhotosListView: View {
    
    @ObservedObject var viewModel: PhotosListViewModel
    
    @State var previews: [String: UIImage] = [:]
    
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
                            let url = photo.download_url
                            NavigationLink {
                                PhotoDetailsView(urlStr: url)
                            } label: {
                                HStack {
                                    Text(photo.author)
                                    Spacer()
                                    if let preview = previews[url] {
                                        Image(uiImage: preview)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                    else {
                                        ProgressView()
                                    }
                                }
                                .frame(height: 100)
                            }
                            .onAppear {
                                Task {
                                    previews[url] = try? await Server().photo(urlStr: photo.download_url)
                                }
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
    
    var body: some View {
        Text("")
    }
}

#Preview {
    @Previewable @StateObject var photosVM = PhotosListViewModel()
    PhotosListView(viewModel: photosVM)
}
