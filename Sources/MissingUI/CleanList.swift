//
//  CleanList.swift
//  Runes
//
//  Created by Tiziano Coroneo on 20/10/2019.
//  Copyright © 2019 Tiziano Coroneo. All rights reserved.
//

import SwiftUI

/// A `List` that does not display the "arrow" disclosure indicator when embedding a `NavigationLink`.
@available(iOS 13.0, *)
public struct CleanList<
    DataCollection: RandomAccessCollection,
    SelectionValue: Hashable,
    Destination: View,
    RowContent: View
>: View {

    // MARK: - Properties

    @State private var selection: SelectionValue?

    private let content: DataCollection
    private let id: KeyPath<DataCollection.Element, SelectionValue>
    private let destination: (DataCollection.Element) -> Destination
    private let rowContent: (DataCollection.Element) -> RowContent

    // MARK: - Initializer

    /// Initializes a `List` by also providing a `destination` `View`for each element.
    /// - Parameter content: Collection of data.
    /// - Parameter id: Keypath that defines how to identify each different element of the collection.
    /// - Parameter destination: The destination `View` to display when the corresponding row is pressed.
    /// - Parameter rowContent: The content `View` to display for each element of the collection.
    public init(
        content: DataCollection,
        id: KeyPath<DataCollection.Element, SelectionValue>,
        destination: @escaping (DataCollection.Element) -> Destination,
        rowContent: @escaping (DataCollection.Element) -> RowContent
    ) {
        self.content = content
        self.id = id
        self.destination = destination
        self.rowContent = rowContent
    }

    // MARK: - Body

    public var body: some View {
        List(self.content, id: id, selection: $selection) {
            (data: DataCollection.Element) in

            HStack(spacing: 0) {
                NavigationLink(
                    destination: self.destination(data),
                    tag: data[keyPath: self.id],
                    selection: self.$selection) {
                        EmptyView()
                }
                .frame(width: 0, height: 0)

                self.rowContent(data)
            }
        }
    }
}
