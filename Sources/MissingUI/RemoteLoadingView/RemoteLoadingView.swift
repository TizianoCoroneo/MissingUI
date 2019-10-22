//
//  RemoteDataView.swift
//  Runes
//
//  Created by Tiziano Coroneo on 20/10/2019.
//  Copyright © 2019 Tiziano Coroneo. All rights reserved.
//

import SwiftUI

/**
 This utility `View` takes a `Loading` value, and displays a `SuccessView` if that value is a `.success` (passing the data inside the `@ViewBuilder successView` closure), displays a `FailureView` if the value is a `.failure` (passing the corresponding `Error` inside the closure), and displays a `LoadingView` otherwise (in case of the `.loading` state).

 It is a workaround for the current state of `@ViewBuilder`, which does not allow any flow control statements except the barebone `if condition`.

 - See also: `ResultView`
*/
@available(iOS 13.0, *)
public struct RemoteLoadingView<
    Success,
    Failure: Error,
    SuccessView: View,
    LoadingView: View,
    FailureView: View
>: View {

    // MARK: - Properties

    private let loadingData: Loading<Success, Failure>

    /// The view to display the `.success` case.
    private let successView: (Success) -> SuccessView

    /// The view to display the `.loading` case.
    private let loadingView: () -> LoadingView

    /// The view to display the `.failure` case.
    private let failureView: (Failure) -> FailureView

    // MARK: - Initializer

    public init(
        _ loadingData: Loading<Success, Failure>,
        @ViewBuilder successView: @escaping (Success) -> SuccessView,
        @ViewBuilder loadingView: @escaping () -> LoadingView,
        @ViewBuilder failureView: @escaping (Failure) -> FailureView
    ) {
        self.loadingData = loadingData
        self.successView = successView
        self.loadingView = loadingView
        self.failureView = failureView
    }

    // MARK: - Body

    public var body: some View {
        Group {
            if loadingData.isSuccess {
                successView(loadingData.data!)
            } else if loadingData.isFailure {
                failureView(loadingData.error!)
            } else {
                loadingView()
            }
        }
    }
}
