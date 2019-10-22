//
//  ResultView.swift
//  TestSwiftUI
//
//  Created by Tiziano Coroneo on 16/10/2019.
//  Copyright © 2019 Tiziano Coroneo. All rights reserved.
//

import SwiftUI

/**
This utility `View` takes a `Result` value, and displays a `SuccessView` if that value is a `.success` (passing the data inside the `@ViewBuilder successView` closure), and displays a `FailureView` otherwise, passing the corresponding `Error` inside the closure.

It is a workaround for the current state of `@ViewBuilder`, which does not allow any flow control statements except the barebone `if condition`.
*/
@available(iOS 13.0, *)
public struct ResultView<SuccessView: View, FailureView: View, Success, Failure: Error>: View {

    // MARK: - Properties

    /// The result that decides which view to display.
    private var result: Result<Success, Failure>

    /// The view to display the `.success` case.
    private let successView: (Success) -> SuccessView

    /// The view to display the `.failure` case.
    private let failureView: (Failure) -> FailureView

    // MARK: - Initializer

    public init(
        _ result: Result<Success, Failure>,
        @ViewBuilder successView: @escaping (Success) -> SuccessView,
        @ViewBuilder failureView: @escaping (Failure) -> FailureView
    ) {
        self.result = result
        self.successView = successView
        self.failureView = failureView
    }

    // MARK: - Section of ugly code only needed until SwiftUI grows up

    private var isSuccess: Bool {
        switch result {
        case .success: return true
        case .failure: return false
        }
    }

    private var unsafeSuccessValue: Success {
        guard case .success(let value) = result
            else { fatalError("Should not ever get here") }
        return value
    }

    private var unsafeErrorData: Failure {
        guard case .failure(let error) = result
            else { fatalError("Should not ever get here") }
        return error
    }

    // MARK: - Body

    public var body: some View {
        Group {
            if isSuccess {
                successView(unsafeSuccessValue)
            } else {
                failureView(unsafeErrorData)
            }
        }
    }
}
