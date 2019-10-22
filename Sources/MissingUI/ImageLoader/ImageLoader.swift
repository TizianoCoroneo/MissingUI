//
//  RemoteImageView.swift
//  Runes
//
//  Created by Tiziano Coroneo on 20/10/2019.
//  Copyright © 2019 Tiziano Coroneo. All rights reserved.
//

import SwiftUI
import Combine

@available(iOS 13.0, *)
public class ImageLoader: ObservableObject {
    public static var defaultSession: URLSession = .shared
    
    public static var defaultCachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad

    public static var defaultShouldBreakpointOnError: Bool = false

    @Published public var image: UIImage

    private let session: URLSession
    private let shouldBreakpointOnError: Bool
    private var cancellable: AnyCancellable?

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
            .tryMap { data, response in
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
        }
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
