//
//  SheetButton.swift
//  
//
//  Created by Tiziano Coroneo on 27/10/2019.
//

import Foundation
import SwiftUI

public struct SheetButton<Destination: View>: View {

    @State private var isPresented: Bool = false

    private let title: String
    private let destination: (Binding<Bool>) -> Destination

    public init(
        title: String,
        @ViewBuilder destination: @escaping (Binding<Bool>) -> Destination
    ) {
        self.title = title
        self.destination = destination
    }

    public var body: some View {
        Button(
            title,
            action: {
                self.isPresented = true
        }).sheet(isPresented: self.$isPresented) {
            self.destination(self.$isPresented)
        }
    }
}
