//
//  BlurEffectView.swift
//  Runes
//
//  Created by Tiziano Coroneo on 20/10/2019.
//  Copyright © 2019 Tiziano Coroneo. All rights reserved.
//

import SwiftUI

/**
 SwiftUI `View` embedding a UIKit `UIBlurEffect`.
 You have to choose a specific `UIBlurEffect.Style`.
 */
@available(iOS 13.0, *)
public struct BlurEffectView: UIViewRepresentable {

    private let blurEffectStyle: UIBlurEffect.Style

    public init(
        blurEffectStyle: UIBlurEffect.Style
    ) {
        self.blurEffectStyle = blurEffectStyle
    }

    public func makeUIView(
        context: UIViewRepresentableContext<BlurEffectView>
    ) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: blurEffectStyle)
        return UIVisualEffectView(effect: blurEffect)
    }

    public func updateUIView(
        _ uiView: UIVisualEffectView,
        context: UIViewRepresentableContext<BlurEffectView>
    ) {}
}
