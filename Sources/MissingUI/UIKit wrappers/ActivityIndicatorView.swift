//
//  ActivityIndicatorView.swift
//  Runes
//
//  Created by Tiziano Coroneo on 20/10/2019.
//  Copyright © 2019 Tiziano Coroneo. All rights reserved.
//

import SwiftUI

/**
 SwiftUI `View` embedding a UIKit `UIActivityIndicatorView`.
 You can optionally provide a `UIActivityIndicatorView.Style`: the main `init()` defaults to `.large`.
 */
@available(iOS 13.0, *)
public struct ActivityIndicatorView: UIViewRepresentable {

    private let style: UIActivityIndicatorView.Style

    public init(
        style: UIActivityIndicatorView.Style = .large
    ) {
        self.style = style
    }

    public func makeUIView(
        context: UIViewRepresentableContext<ActivityIndicatorView>
    ) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: style)
        view.startAnimating()
        return view
    }

    public func updateUIView(
        _ uiView: UIActivityIndicatorView,
        context: UIViewRepresentableContext<ActivityIndicatorView>) {}
}
