//
//  RemoteImage.swift
//  
//
//  Created by Tiziano Coroneo on 27/10/2019.
//

import Foundation
import SwiftUI

public struct RemoteImage<V: View>: View {

    @ObservedObject private var loader: ImageLoader
    private let imageConfiguration: (Image) -> V

    public init(
        loader: ImageLoader,
        @ViewBuilder _ imageConfiguration: @escaping (Image) -> V
    ) {
        self.loader = loader
        self.imageConfiguration = imageConfiguration
    }

    public init(
        url: URL,
        placeholder: UIImage? = nil,
        cachePolicy: URLRequest.CachePolicy = ImageLoader.defaultCachePolicy,
        session: URLSession = ImageLoader.defaultSession,
        shouldBreakpointOnError: Bool = ImageLoader.defaultShouldBreakpointOnError,
        @ViewBuilder _ imageConfiguration: @escaping (Image) -> V
    ) {
        self.loader = ImageLoader(
            url: url,
            placeholder: placeholder,
            cachePolicy: cachePolicy,
            session: session,
            shouldBreakpointOnError: shouldBreakpointOnError)
        self.imageConfiguration = imageConfiguration
    }

    public var body: some View {
        imageConfiguration(
            Image(uiImage: self.loader.image))
    }
}
