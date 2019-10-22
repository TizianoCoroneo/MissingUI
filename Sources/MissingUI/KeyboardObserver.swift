//
//  KeyboardObserver.swift
//  TestSwiftUI
//
//  Created by Tiziano Coroneo on 16/10/2019.
//  Copyright © 2019 Tiziano Coroneo. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

/**
 This `ObservableObject` checks if the keyboard is currently open, and updates the `currentKeyboardHeight` whenever the keyboard frame changes, or the keyboars will be shown or hidden.

 At this moment `currentKeyboardHeight` returns the actual `frame` height of the keyboard, taking account also the zone outside the `safeArea`. Depending on the layout of the screen where this is used, this may be desirable or not.
 */
@available(iOS 13.0, *)
public final class KeyboardObserver: ObservableObject {

    @Published public var currentKeyboardHeight: CGFloat = 0

    private var notificationCenter: NotificationCenter
    private var cancellable: Cancellable?

    public init(center: NotificationCenter = .default) {
        // TODO: Add an option to exclude the `safeArea` height from the keyboard height.

        notificationCenter = center

        let willShowPublisher = notificationCenter
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { (notification: Notification) -> CGFloat? in
                guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
                    .cgRectValue
                    else { return nil }
                return keyboardSize.height
        }

        let willHidePublisher = notificationCenter
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat.zero }

        let willChangeFrame = notificationCenter
            .publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .compactMap { (notification: Notification) -> CGFloat? in
                    guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
                        .cgRectValue
                        else { return nil }
                    return keyboardSize.height
        }

        cancellable = Publishers.Merge3(
            willChangeFrame,
            willShowPublisher,
            willHidePublisher)
            .assign(to: \.currentKeyboardHeight, on: self)
    }
}
