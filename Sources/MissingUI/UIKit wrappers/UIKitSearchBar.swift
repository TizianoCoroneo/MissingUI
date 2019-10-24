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
        if query != searchBar.text {
            searchBar.text = query
        }

        // The double condition is a trick to avoid `Modifying state during view update, this will cause undefined behavior.` runtime warning.
        if isEditing, !searchBar.isFirstResponder {
            searchBar.becomeFirstResponder()
        } else if !isEditing, searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }

    public func makeCoordinator() -> UIKitSearchBar.Coordinator {
        return Coordinator(self)
    }

    public class Coordinator: NSObject, UISearchBarDelegate {

        private let view: UIKitSearchBar

        private let query: Binding<String>
        private let isEditing: Binding<Bool>

        public init(_ view: UIKitSearchBar) {
            self.view = view
            self.query = view._query
            self.isEditing = view._isEditing
        }

        // MARK: - UISearchBarDelegate

        public func searchBarCancelButtonClicked(
            _ searchBar: UISearchBar
        ) {
            self.query.wrappedValue = ""
        }

        public func searchBarTextDidBeginEditing(
            _ searchBar: UISearchBar
        ) {
            self.isEditing.wrappedValue = true
        }

        public func searchBarShouldBeginEditing(
            _ searchBar: UISearchBar
        ) -> Bool {
            // Updates the value of the `isEditing` state when the UIKit delegate is invoked.
            // The double condition is a trick to avoid `Modifying state during view update, this will cause undefined behavior.` runtime warning.
            if !searchBar.isFirstResponder, !self.isEditing.wrappedValue {
                self.isEditing.wrappedValue = true
            }
            return true
        }

        public func searchBarShouldEndEditing(
            _ searchBar: UISearchBar
        ) -> Bool {
            // Updates the value of the `isEditing` state when the UIKit delegate is invoked.
            // The double condition is a trick to avoid `Modifying state during view update, this will cause undefined behavior.` runtime warning.
            if searchBar.isFirstResponder, self.isEditing.wrappedValue {
                self.isEditing.wrappedValue = false
            }
            return true
        }

        public func searchBar(
            _ searchBar: UISearchBar,
            textDidChange searchText: String
        ) {
            self.view.query = searchBar.text ?? ""
        }
    }
}
