//
//  PictureDTO.swift
//  PicturesViewerFromBook
//
//  Created by Sergey Kozlov on 22.09.2026.
//

import Foundation

struct PictureDTO: Codable {
    var id: String
    var width: Int
    var height: Int
    var url: String
    var author: String
    var download_url: String
}
