//
//  SheetButton.swift
//  
//
//  Created by Tiziano Coroneo on 27/10/2019.
//

import Foundation
import SwiftUI

public struct SheetButton<Configured: View, Destination: View>: View {

    @State private var isPresented: Bool = false

    private let title: String
    private let configuration: (Button<Text>) -> Configured
    private let destination: (Binding<Bool>) -> Destination

    public init(
        title: String,
        @ViewBuilder configuration: @escaping (Button<Text>) -> Configured,
        @ViewBuilder destination: @escaping (Binding<Bool>) -> Destination
    ) {
        self.title = title
        self.configuration = configuration
        self.destination = destination
    }

    public var body: some View {
        self.configuration(Button.init(
            title,
            action: {
                self.isPresented = true
        })).sheet(isPresented: self.$isPresented) {
            self.destination(self.$isPresented)
        }
    }
}

extension SheetButton where Configured == Button<Text> {
    public init(
        title: String,
        @ViewBuilder destination: @escaping (Binding<Bool>) -> Destination
    ) {
        self.init(
            title: title,
            configuration: { $0 },
            destination: destination)
    }
}
