//
//  HiddenNavigationLink.swift
//  Runes
//
//  Created by Tiziano Coroneo on 05/12/2019.
//  Copyright © 2019 Tiziano Coroneo. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
struct HiddenNavigationLink<
    Destination: View,
    Label: View,
    CustomButton: View
>: View {
    @State private var isActive = false

    private let destination: Destination
    private let label: () -> Label
    private let button: (SwiftUI.Button<Label>) -> CustomButton

    init(
        destination: Destination,
        @ViewBuilder label: @escaping () -> Label,
                     @ViewBuilder button: @escaping (SwiftUI.Button<Label>) -> CustomButton
    ) {
        self.destination = destination
        self.label = label
        self.button = button
    }

    var body: some View {
        HStack(spacing: 0) {
            NavigationLink(
                destination: destination,
                isActive: $isActive
            ) {
                EmptyView()
            }
            .frame(width: 0)
            .accessibilityElement(children: .ignore)
            .accessibility(hidden: true)

            self.button(
                SwiftUI.Button(action: {
                    self.isActive = true
                }, label: label))
        }
    }
}

@available(iOS 13.0, macOS 10.15, *)
extension HiddenNavigationLink where CustomButton == SwiftUI.Button<Label> {
    init(
        destination: Destination,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.init(
            destination: destination,
            label: label,
            button: { $0 })
    }
}
