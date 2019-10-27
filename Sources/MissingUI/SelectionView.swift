//
//  SelectionView.swift
//  TestSwiftUI
//
//  Created by Tiziano Coroneo on 16/10/2019.
//  Copyright © 2019 Tiziano Coroneo. All rights reserved.
//

import Foundation
import SwiftUI

/// A View used to make selections from a list.
/// It supports different kinds of selection; see `SelectionView.SelectionType`.
@available(iOS 13.0, *)
public struct SelectionView<Value: Hashable, Options: RandomAccessCollection, Label: View>: View
where Options.Element == Value
{

    // MARK: - Selection type

    /**
     The type of selection to use.

     `mandatorySingleSelection` allows selecting at most 1 element, and will not allow deselecting it.

     `mandatorySingleSelectionWithDefaultValue` allows selecting at most 1 element, and will automatically select the chosen `defaultValue` if the user tries to deselect it.

     `optionalSingleSelection` allows selecting 0 or 1 elements, thus allowing deselection of the single element.

     `multipleSelection` allows selecting multiple elements, and it is possible to specify a minimum and a maximum count of selected elements. It will disallow any selection that goes over or under the limits.
     If `allCasesValue` is provided, then there is some additional logic:
     - if `allCasesValue` is selected, all other values are deselected (as they are already included);
     - if `allCasesValue` is deselected, the previous selection state is restored (if the previous selection state cannot be restored, it will select the first option in `options` order);
     - if a different value is selected while `allCasesValue` is selected, then `allCasesValue` is deselected.
     - if all values except `allCasesValue` are selected, then they are all deselected and `allCasesValue` is selected instead.

     */
    public enum SelectionType {
        case mandatorySingleSelection
        case mandatorySingleSelectionWithDefaultValue(defaultValue: Value)
        case optionalSingleSelection
        case multipleSelection(
            minimumSelectionCount: Int = 0,
            maximumSelectionCount: Int = .max,
            allCasesValue: Value? = nil)
    }

    // MARK: - Properties

    /// The list of options that is possible to select.
    public let options: Options

    /// A `Binding` that mantains the `Set` of selected `Value`s.
    @Binding public var optionsSelection: Set<Value>

    /// The type of selection that will be allowed on this view. See `SelectionView.SelectionType` for more details.
    public let selectionType: SelectionType

    /// The `View` that provides the appearance for the corresponding row for the provided `Value` and `Binding<Bool>`.
    public let label: (Value, _ isSelected: Binding<Bool>) -> Label

    /// The previous set of selected items before the current one. It is only used and updated in case the `selectionType` is `multipleSelection` and a `allCasesValue` is provided.
    @State private var previousSelectionSet: Set<Value>? = nil

    // MARK: - Initializer

    /// Initialize a new `SelectionView`.
    /// - Parameter content: List of selectable options.
    /// - Parameter selectionType: Type of allowed/disallowed selections. See `SelectionView.SelectionType` for more details.
    /// - Parameter selectionBinding: A `Binding` that receives the `Set` of currently selected `Value`s.
    /// - Parameter label: The `View` that provides the appearance for the corresponding `SelectionRow` for the provided `Value`.
    public init(
        content: Options,
        selectionType: SelectionType,
        selectionBinding: Binding<Set<Value>>,
        @ViewBuilder label: @escaping (Value, _ isSelected: Binding<Bool>) -> Label
    ) {
        self.options = content
        self.selectionType = selectionType
        self._optionsSelection = selectionBinding
        self.label = label
    }

    // MARK: - Binding functions selector

    private func selectionBinding(forKey key: Value) -> Binding<Bool> {
        switch selectionType {
        case .mandatorySingleSelection:
            return mandatorySingleSelectionBinding(forKey: key)
        case .mandatorySingleSelectionWithDefaultValue(defaultValue: let defaultValue):
            return mandatorySingleSelectionBindingWithDefaultValue(defaultValue: defaultValue, forKey: key)
        case .optionalSingleSelection:
            return optionalSingleSelectionBinding(forKey: key)
        case .multipleSelection(
            minimumSelectionCount: let minimum,
            maximumSelectionCount: let maximum,
            allCasesValue: let allCasesValue):
            return multipleSelectionBinding(
                minimumSelectionCount: minimum,
                maximumSelectionCount: maximum,
                allCasesValue: allCasesValue,
                forKey: key)
        }
    }

    // MARK: - Binding functions definitions

    private func mandatorySingleSelectionBinding(forKey key: Value) -> Binding<Bool> {
        Binding(
            get: { [optionsSelection] in
                return optionsSelection.contains(key)
            },
            set: { (value: Bool) in
                self.optionsSelection.removeAll()
                self.optionsSelection.insert(key)
        })
    }

    private func mandatorySingleSelectionBindingWithDefaultValue(
        defaultValue: Value,
        forKey key: Value
    ) -> Binding<Bool> {
        Binding(
            get: { [optionsSelection] in
                return optionsSelection.contains(key)
            },
            set: { (value: Bool) in
                if self.optionsSelection.contains(key) {
                    self.optionsSelection.remove(key)
                    if self.optionsSelection.count == 0 {
                        self.optionsSelection.insert(defaultValue)
                    }
                } else {
                    self.optionsSelection.removeAll()
                    self.optionsSelection.insert(key)
                }
        })
    }

    private func optionalSingleSelectionBinding(forKey key: Value) -> Binding<Bool> {
        Binding(
            get: { [optionsSelection] in
                return optionsSelection.contains(key)
            },
            set: { (value: Bool) in
                if self.optionsSelection.contains(key) {
                    self.optionsSelection.remove(key)
                } else {
                    self.optionsSelection.removeAll()
                    self.optionsSelection.insert(key)
                }
        })
    }

    private func multipleSelectionBinding(
        minimumSelectionCount: Int = 0,
        maximumSelectionCount: Int = Int.max,
        allCasesValue: Value?,
        forKey key: Value
    ) -> Binding<Bool> {
        Binding(
            get: { [optionsSelection] in
                return optionsSelection.contains(key)
            },
            set: { (value: Bool) in

                if
                    /// If you select `allCasesValue`, and is not already selected...
                    let allCasesValue = allCasesValue,
                    key == allCasesValue,
                    !self.optionsSelection.contains(allCasesValue) {

                    /// Save the previous selection in case the user deselects `allCasesValue` to restore it.
                    self.previousSelectionSet = self.optionsSelection
                    /// Remove everything and insert `allCasesValue`
                    self.optionsSelection.removeAll()
                    self.optionsSelection.insert(allCasesValue)


                } else if
                    /// If you select `allCasesValue` and it is already selected...
                    let allCasesValue = allCasesValue,
                    key == allCasesValue,
                    self.optionsSelection.contains(allCasesValue) {

                    /// Restore the previous selection, or set the first option available as selected if none.
                    // FIXME: Should take into account `minimumSelectionCount`, but I have no clue on how to deal with this case.
                    self.optionsSelection = self.previousSelectionSet
                        ?? self.options.first.map { Set([$0]) }
                        ?? []

                } else if
                    /// If a different value is selected and also `allCasesValue` is selected...
                    let allCasesValue = allCasesValue,
                    key != allCasesValue,
                    self.optionsSelection.contains(allCasesValue) {

                    /// Remove `allCasesValue` and insert the value.
                    self.optionsSelection.remove(allCasesValue)
                    self.optionsSelection.insert(key)

                } else if
                    /// If a different value is selected, both the value and `allCasesValue` are not selected, and everything else is...
                    let allCasesValue = allCasesValue,
                    key != allCasesValue,
                    !self.optionsSelection.contains(allCasesValue),
                    !self.optionsSelection.contains(key),
                    self.optionsSelection.count == self.options.count - 2 {

                    /// Save the previous selection set in case we want to restore it
                    self.previousSelectionSet = self.optionsSelection
                    /// Remove everything and insert `allCasesValue`
                    self.optionsSelection.removeAll()
                    self.optionsSelection.insert(allCasesValue)

                } else if
                    /// If the value is already selected, and we're above the minimum count...
                    self.optionsSelection.contains(key),
                    self.optionsSelection.count > minimumSelectionCount {

                    /// Remove the value.
                    self.optionsSelection.remove(key)

                } else if
                    /// If the value is not already selected, and we're below the maximum selection value...
                    self.optionsSelection.count < maximumSelectionCount {

                    /// Insert the value.
                    self.optionsSelection.insert(key)
                }
                /// Any other case (most likely going above the maximum limit, if set) are going to do nothing.
        })
    }

    // MARK: - Body

    public var body: some View {
        ForEach(options, id: \.self) { (key: Value) in
            self.label(key, self.selectionBinding(forKey: key))
        }
    }
}
