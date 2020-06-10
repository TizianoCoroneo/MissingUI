//
//  APIError.swift
//  Runes
//
//  Created by Tiziano Coroneo on 20/10/2019.
//  Copyright © 2019 Tiziano Coroneo. All rights reserved.
//

import Foundation

/// All the errors that can be thrown from `ImageLoader`
enum ImageLoaderError: LocalizedError {

    /// Received an invalid HTTP code. Print it to get a localized description of it.
    case invalidHTTPCode(Int, Data)

    /// Received (somehow) a response that is not a `HTTPURLResponse` code.
    case notHTTPResponse(URLResponse, Data)

    /// The data retrieved from the URL is not convertible to a `UIImage`.
    case notAnImage(URLResponse, Data)

    // MARK: - Error descriptions

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

    var invalidHTTPCode: (Int, Data)? {
        get {
            guard case let .invalidHTTPCode(value) = self else { return nil }
            return value
        }
        set {
            guard case .invalidHTTPCode = self, let newValue = newValue else { return }
            self = .invalidHTTPCode(newValue.0, newValue.1)
        }
    }

    var notHTTPResponse: (URLResponse, Data)? {
        get {
            guard case let .notHTTPResponse(value) = self else { return nil }
            return value
        }
        set {
            guard case .notHTTPResponse = self, let newValue = newValue else { return }
            self = .notHTTPResponse(newValue.0, newValue.1)
        }
    }

    var notAnImage: (URLResponse, Data)? {
        get {
            guard case let .notAnImage(value) = self else { return nil }
            return value
        }
        set {
            guard case .notAnImage = self, let newValue = newValue else { return }
            self = .notAnImage(newValue.0, newValue.1)
        }
    }
}
