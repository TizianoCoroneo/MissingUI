//
//  Publisher+convertToResult.swift
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
     Converts a `Publisher<Output, Failure>` in a `Publisher<Result<Output, Failure>, Never>`.

     This allows you to use a failable `Publisher` with the `.assign` `Subscriber` that does not allow failable initializers.
     Once you have the result of this function, you can use it together with a `ResultView` to display a certain `View` for the `.success` case, and a different one for the `.failure` case.
     */
    func convertToResult() -> AnyPublisher<Result<Self.Output, Self.Failure>, Never> {
        map { .success($0) }.catch { Just(.failure($0)) }.eraseToAnyPublisher()
    }
}
