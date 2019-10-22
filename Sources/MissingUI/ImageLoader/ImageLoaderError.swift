//
//  APIError.swift
//  Runes
//
//  Created by Tiziano Coroneo on 20/10/2019.
//  Copyright © 2019 Tiziano Coroneo. All rights reserved.
//

import Foundation

enum ImageLoaderError: LocalizedError {
    case invalidHTTPCode(Int, Data)
    case notHTTPResponse(URLResponse, Data)
    case notAnImage(URLResponse, Data)

    var errorDescription: String? {
        switch self {
        case .invalidHTTPCode(let code, let data):
            return """
            \(HTTPURLResponse.localizedString(forStatusCode: code))
            \(String(data: data, encoding: .utf8)!)
            """

        case .notHTTPResponse(let response, let data):
            return """
            \(String(describing: response))
            \(String(data: data, encoding: .utf8)!)
            """

        case .notAnImage(let response, let data):
            return """
            \(String(describing: response))
            \(String(data: data, encoding: .utf8)!)
            """
        }
    }
}
