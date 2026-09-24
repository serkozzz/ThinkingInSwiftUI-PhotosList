//
//  ServerAPIError.swift
//  PicturesViewerFromBook
//
//  Created by Sergey Kozlov on 23.09.2026.
//

import SwiftUI

enum ServerAPIError: String, Identifiable {
    case timeout
    case noInternet
    case unknown
    case invalidJSON
    case invalidImageData
    case invalidURL
    case cancellation
    case explicitMaterialsError //just for example
    
    var id: String {
        self.rawValue
    }
}

extension ServerAPIError: Error  {
    init(urlError: URLError) {
        switch urlError.code {
        case .notConnectedToInternet,
             .networkConnectionLost,
             .cannotFindHost,
             .cannotConnectToHost:
            self = .noInternet

        case .timedOut:
            self = .timeout

        default:
            self = .unknown
        }
    }
}

extension ServerAPIError {
    static func from(statusCode: Int) -> ServerAPIError {
        switch statusCode {
        case 401...404:
            .unknown

        case 500..<600:
            .unknown

        default:
            .unknown
        }
    }
}
