//
//  PhotoMetadata.swift
//  PhotosList
//
//  Created by Sergey Kozlov on 17.06.2025.
//
import Foundation

class PhotoMetadata : Codable, Identifiable {
    var id: String
    var author: String
    var width: Int
    var height: Int
    var url: String
    var download_url: String
}
