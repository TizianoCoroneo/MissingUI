//
//  RemoteImageView.swift
//  Runes
//
//  Created by Tiziano Coroneo on 20/10/2019.
//  Copyright © 2019 Tiziano Coroneo. All rights reserved.
//

import SwiftUI
import Combine

#if canImport(UIKit)
/**
 Utility used to load an `Image`from a `URL`.

 You can specify a placeholder `UIImage`, which `URLSession` to use, which `URLRequest.CachePolicy` to use, and if it should trigger a breakpoint on failure (for debugging purposes).

 You can also specify these values on the `static` properties, to change the default values applied when they are not specified in the `init`.

 All the errors are:
 - or from `URLSession.dataTask`
 - or `ImageLoaderError`
 */
@available(iOS 13.0, *)
public class ImageLoader: ObservableObject {

    // MARK: - Static properties (Defaults)

    /// The `URLSession` to use in case another one is not specified in the `init`.
    public static var defaultSession: URLSession = .shared

    /// The `URLRequest.CachePolicy` to use in case another one is not specified in the `init`.
    public static var defaultCachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad

    /// The `shouldBreakpointOnError` value to use in case another one is not specified in the `init`.
    /// If `true`, it adds a `.breakpointOnError` to the Combine chain used to request the image data.
    public static var defaultShouldBreakpointOnError: Bool = false

    // MARK: - Instance properties

    /// `Published` property that contains the retrieved UIImage data, and makes it available to SwiftUI's `View`s.
    @Published public var image: UIImage

    /// The `URLSession` used to make the HTTP request to the specified `URL`.
    private let session: URLSession

    /// If `true`, it adds a `.breakpointOnError` to the Combine chain used to request the image data.
    private let shouldBreakpointOnError: Bool

    /// `AnyCancellable` that keeps in memory a reference to the Combine chain used to request the image data.
    private var cancellable: AnyCancellable?

    // MARK: - Initializer

    public init(
        url: URL,
        placeholder: UIImage? = nil,
        cachePolicy: URLRequest.CachePolicy = defaultCachePolicy,
        session: URLSession = defaultSession,
        shouldBreakpointOnError: Bool = defaultShouldBreakpointOnError
    ) {
        self.session = session
        self.shouldBreakpointOnError = shouldBreakpointOnError

        let request = URLRequest(
            url: url,
            cachePolicy: cachePolicy)

        // If we have a cached response, do not use the placeholder at all.
        if let cachedResponse = session
            .configuration
            .urlCache?
            .cachedResponse(for: request),
            let cachedImage = UIImage(data: cachedResponse.data) {

            self.image = cachedImage
        } else {
            self.image = placeholder ?? UIImage()
        }

        self.cancellable = session
            .dataTaskPublisher(for: request)
            .tryMap({ data, response in
                guard
                    let httpResponse = response as? HTTPURLResponse
                    else {
                        throw ImageLoaderError.notHTTPResponse(response, data)
                }

                guard
                    200..<300 ~= httpResponse.statusCode
                    else {
                        throw ImageLoaderError.invalidHTTPCode(httpResponse.statusCode, data)
                }

                guard let image = UIImage(data: data)
                    else {
                        throw ImageLoaderError.notAnImage(response, data)
                }

                return image
            })
            .breakpoint(receiveCompletion: {
                switch $0 {
                case .finished: return false
                case .failure: return self.shouldBreakpointOnError
                }
            })
            .replaceError(with: placeholder ?? UIImage())
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}

#endif
