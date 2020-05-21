//
//  BlurEffectView.swift
//  Runes
//
//  Created by Tiziano Coroneo on 20/10/2019.
//  Copyright © 2019 Tiziano Coroneo. All rights reserved.
//

import SwiftUI

#if canImport(UIKit)
/**
 SwiftUI `View` embedding a UIKit `UIBlurEffect`.
 You have to choose a specific `UIBlurEffect.Style`.
 */
@available(iOS 13.0, *)
public struct BlurEffectView: UIViewRepresentable {

    private let blurEffectStyle: UIBlurEffect.Style
    private let backgroundColor: UIColor

    public init(
        blurEffectStyle: UIBlurEffect.Style,
        backgroundColor: UIColor = .clear
    ) {
        self.blurEffectStyle = blurEffectStyle
        self.backgroundColor = backgroundColor
    }

    public func makeUIView(
        context: UIViewRepresentableContext<BlurEffectView>
    ) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: blurEffectStyle)
        let view = UIVisualEffectView(effect: blurEffect)
        view.backgroundColor = self.backgroundColor
        return view
    }

    public func updateUIView(
        _ view: UIVisualEffectView,
        context: UIViewRepresentableContext<BlurEffectView>
    ) {
        view.backgroundColor = self.backgroundColor
    }
}

#elseif canImport(Cocoa)

@available(macOS 10.15, *)
public struct BlurEffectView: NSViewRepresentable {
    public typealias NSViewType = NSVisualEffectView

    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode
    var state: NSVisualEffectView.State
    var maskImage: NSImage?
    var isEmphasized: Bool

    init(
        material: NSVisualEffectView.Material = .appearanceBased,
        blendingMode: NSVisualEffectView.BlendingMode = .behindWindow,
        state: NSVisualEffectView.State = .active,
        maskImage: NSImage? = nil,
        isEmphasized: Bool = false
    ) {
        self.material = material
        self.blendingMode = blendingMode
        self.state = state
        self.maskImage = maskImage
        self.isEmphasized = isEmphasized
    }

    public func makeNSView(
        context: NSViewRepresentableContext<BlurEffectView>
    ) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = state
        view.maskImage = maskImage
        view.isEmphasized = isEmphasized
        return view
    }

    public func updateNSView(
        _ view: NSVisualEffectView,
        context: NSViewRepresentableContext<BlurEffectView>
    ) {
        view.material = material
        view.blendingMode = blendingMode
        view.state = state
        view.maskImage = maskImage
        view.isEmphasized = isEmphasized
    }
}

#endif
