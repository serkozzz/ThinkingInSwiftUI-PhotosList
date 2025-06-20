//
//  ImageCache.swift
//  PhotosList
//
//  Created by Sergey Kozlov on 20.06.2025.
//

import SwiftUI

actor ImageCache {
    private var cache: [String: UIImage] = [:]

    func get(for url: String) -> UIImage? {
        cache[url]
    }

    func set(_ image: UIImage, for url: String) {
        cache[url] = image
    }
}
