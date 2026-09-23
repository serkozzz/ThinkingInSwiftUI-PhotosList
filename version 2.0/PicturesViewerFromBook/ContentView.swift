//
//  ContentView.swift
//  PicturesViewerFromBook
//
//  Created by Sergey Kozlov on 23.09.2026.
//

import SwiftUI

struct ContentView: View {
    @State var albumViewModel = AlbumViewModel()
    @State var albumIsPresented: Bool = false
    var body: some View {
       
        NavigationStack {
            VStack {
                Button("open album") {
                    albumIsPresented = true
                }
                
            }

            if albumIsPresented {
                AlbumView(viewModel: albumViewModel)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
