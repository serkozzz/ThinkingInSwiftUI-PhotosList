//
//  PhotoDetailsView.swift
//  PhotosList
//
//  Created by Sergey Kozlov on 18.06.2025.
//

import SwiftUI

struct PhotoDetailsView: View {
    
    @StateObject var viewModel: PhotoDetailsViewModel
    
    init(urlStr: String) {
        _viewModel = StateObject(wrappedValue: PhotoDetailsViewModel(url: urlStr))
    }
    
    
    var body: some View {
        VStack {
            if (viewModel.isLoading) {
                ProgressView("Loading...")
                    .scaleEffect(1.5)
            }
            else {
                Image(uiImage: viewModel.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
            }
        }
        .onAppear {
            Task { await viewModel.loadPhoto() }
        }
        .alert(item: $viewModel.error) { err in
            Alert(title: Text("Error"), message: Text(err.message), dismissButton: .default(Text("OK")))
        }
    }
    
}

#Preview {
    PhotoDetailsView(urlStr: "https://picsum.photos/id/0/5000/3333")
}
