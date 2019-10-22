//
//  Publisher+convertToLoading.swift
//  Runes
//
//  Created by Tiziano Coroneo on 17/10/2019.
//  Copyright © 2019 Tiziano Coroneo. All rights reserved.
//

import Foundation
import Combine

@available(iOS 13.0, *)
public extension Publisher {
    /**
     Converts a `Publisher<Output, Failure>` in a `Publisher<Loading<Output, Failure>, Never>`.
     It prepends a `.loading` value to the input publisher, to represent the initial state.

     This allows you to use a failable `Publisher` with the `.assign` `Subscriber` that does not allow failable initializers.
     Once you have the result of this function, you can use it together with a `RemoteLoadingView` to display a certain `View` for the `.success` case, a different one for the `.failure` case and another different `View` for the `.loading` case.
     */
    func convertToLoading() -> AnyPublisher<Loading<Self.Output, Self.Failure>, Never> {
        map { .success($0) }
            .prepend(Loading.loading)
            .catch { Just(.failure($0)) }
            .eraseToAnyPublisher()
    }
}
