//
//  ErrorWrapper.swift
//  PhotosList
//
//  Created by Sergey Kozlov on 17.06.2025.
//

import Foundation

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let error: Error
    
    var message: String {
        error.localizedDescription
    }
}
