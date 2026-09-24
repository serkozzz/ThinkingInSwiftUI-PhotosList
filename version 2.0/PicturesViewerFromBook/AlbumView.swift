//
//  AlbumView.swift
//  PicturesViewerFromBook
//
//  Created by Sergey Kozlov on 23.09.2026.
//

import SwiftUI
import Combine

struct AlbumView: View {
    @ObservedObject var viewModel: AlbumViewModel
    
    var body: some View {
        List(viewModel.items) {
            AlbumItemView(item: $0)
        }
        .task() {
            await viewModel.load()
        }
        .alert(item: $viewModel.errorMessage) {
            Alert(title: Text($0.rawValue))
        }
    }
}


struct AlbumItemView: View {
    @ObservedObject var item: AlbumItemViewModel
    var body: some View {
        HStack {
            Text(item.name)
            if let icon = item.icon {
                Image(uiImage: icon).resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            }
//            AsyncImage(url: URL(string: item.dto.download_url)!) { phase in
//                switch phase {
//                case .empty:
//                    ProgressView().frame(width: 200, height: 200)
//                case .success(let image):
//                    image.resizable().aspectRatio(contentMode: .fit)
//                        .frame(width: 200, height: 200)
//                case .failure(_):
//                    Text("error")
//                @unknown default:
//                    EmptyView()
//                }
//            }
        }
        .task {
            await item.loadImage()
        }
    }
}
