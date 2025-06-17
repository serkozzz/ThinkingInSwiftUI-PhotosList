//
//  ContentView.swift
//  PhotosList
//
//  Created by Sergey Kozlov on 17.06.2025.
//

import SwiftUI

struct PhotosListView: View {
    
    @ObservedObject var viewModel = PhotosListViewModel()
    
    var body: some View {
        if (viewModel.isLoading) {
            Text("Loading...")
        }
        else {
            List() {
                ForEach(viewModel.photos) { photo in
                    Text(photo.author)
                }

                
            }
            .alert(item: $viewModel.error) { err in
                Alert(title: Text("Error"), message: Text(err.message), dismissButton: .default(Text("OK")))
            }
            .padding()
        }
    }
}

#Preview {
    PhotosListView()
}
