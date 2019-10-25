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

        // The `DispatchQueue.main.async` avoids a race condition when triggering the card pull-down-to-release and the searchbar is first responder.
        // The first two conditions are a trick to avoid `Modifying state during view update, this will cause undefined behavior.` runtime warning.
        // The last condition is to avoid a crash in SwiftUI, triggered if this view has `isEditing` set to `true` during its presentation.
        // Not proud of this.
        DispatchQueue.main.async {
            if self.isEditing,
                !searchBar.isFirstResponder,
                searchBar.window != nil {
                searchBar.becomeFirstResponder()
            } else if !self.isEditing,
                searchBar.isFirstResponder {
                searchBar.resignFirstResponder()
            }
        }
    }

    public func makeCoordinator() -> UIKitSearchBar.Coordinator {
        return Coordinator(self)
    }

    public class Coordinator: NSObject, UISearchBarDelegate {

        @Binding private var query: String
        @Binding private var isEditing: Bool

        public init(_ view: UIKitSearchBar) {
            self._query = view._query
            self._isEditing = view._isEditing
        }

        // MARK: - UISearchBarDelegate

        public func searchBarCancelButtonClicked(
            _ searchBar: UISearchBar
        ) {
            self.query = ""
        }

        public func searchBar(
            _ searchBar: UISearchBar,
            textDidChange searchText: String
        ) {
            self.query = searchBar.text ?? ""
        }

        public func searchBarTextDidBeginEditing(
            _ searchBar: UISearchBar
        ) {
            // Updates the value of the `isEditing` state when the UIKit delegate is invoked.
            // The double condition is a trick to avoid `Modifying state during view update, this will cause undefined behavior.` runtime warning.
            if !searchBar.isFirstResponder,
                !self.isEditing {
                self.isEditing = true
            }
        }

        public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            // Updates the value of the `isEditing` state when the UIKit delegate is invoked.
            // The double condition is a trick to avoid `Modifying state during view update, this will cause undefined behavior.` runtime warning.
            if searchBar.isFirstResponder,
                self.isEditing {
                self.isEditing = false
            }
        }
    }
}

#if DEBUG
@available(iOS 13.0, *)
struct UIKitSearchBar_Previews: PreviewProvider {

    struct TestView: View {

        @State var query: String = "Hello search!"
        @State var isEditing: Bool = true

        var body: some View {
            VStack {
                UIKitSearchBar(
                    query: $query,
                    isEditing: $isEditing)

                Text("Query: \(query)")
            }
        }
    }

    struct MockError: LocalizedError {
        let errorDescription: String?
    }

    static var previews: some View {
        TestView()
            .previewLayout(PreviewLayout.fixed(width: 200, height: 150))
    }
}

#endif
