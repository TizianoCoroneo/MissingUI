//
//  File.swift
//  
//
//  Created by Tiziano Coroneo on 22/10/2019.
//

import SwiftUI

/**
 SwiftUI `View` embedding a UIKit `UISearchBar`.
 It automatically updates its `query` biding while the user writes the text, without waiting for the `Search` button to be pressed.
*/
@available(iOS 13.0, *)
public struct UIKitSearchBar: UIViewRepresentable {

    // MARK: - Properties

    /// Binding that represents the textfield's current query.
    @Binding public var query: String

    /// Binding that represents if the `searchBar` is currently focused or not.
    @Binding public var isEditing: Bool

    /// The textfield's placeholder text.
    private let placeholderText: String

    // MARK: - Initializer

    /// Initalizes a `View` that embed a `UISearchBar` from UIKit.
    /// - Parameter placeholderText: The textfield's placeholder text.
    /// - Parameter query: Binding that represents the textfield's current query.
    /// - Parameter isEditing: Binding that represents if the `searchBar` is currently focused or not.
    public init(
        placeholderText: String = "",
        query: Binding<String>,
        isEditing: Binding<Bool>
    ) {
        self._query = query
        self._isEditing = isEditing
        self.placeholderText = placeholderText
    }

    // MARK: - UIViewRepresentable implementation

    public func makeUIView(
        context: UIViewRepresentableContext<UIKitSearchBar>
    ) -> UISearchBar {
        let bar = UISearchBar()

        bar.placeholder = placeholderText
        bar.delegate = context.coordinator

        return bar
    }

    public func updateUIView(
        _ searchBar: UISearchBar,
        context: UIViewRepresentableContext<UIKitSearchBar>
    ) {
        searchBar.text = query

        if isEditing {
            searchBar.becomeFirstResponder()
        } else {
            searchBar.resignFirstResponder()
        }
    }

    public func makeCoordinator() -> UIKitSearchBar.Coordinator {
        return Coordinator(self)
    }

    public class Coordinator: NSObject, UISearchBarDelegate {

        private let view: UIKitSearchBar

        public init(_ view: UIKitSearchBar) {
            self.view = view
        }

        // MARK: - UISearchBarDelegate

        public func searchBarCancelButtonClicked(
            _ searchBar: UISearchBar
        ) {
            self.view.query = ""
        }

        public func searchBarTextDidBeginEditing(
            _ searchBar: UISearchBar
        ) {
            self.view.isEditing = true
        }

        public func searchBarTextDidEndEditing(
            _ searchBar: UISearchBar
        ) {
            self.view.isEditing = false
        }

        public func searchBar(
            _ searchBar: UISearchBar,
            textDidChange searchText: String
        ) {
            self.view.query = searchBar.text ?? ""
        }
    }
}
