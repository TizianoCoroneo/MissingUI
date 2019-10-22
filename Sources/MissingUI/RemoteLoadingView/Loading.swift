//
//  Loading.swift
//  Runes
//
//  Created by Tiziano Coroneo on 20/10/2019.
//  Copyright © 2019 Tiziano Coroneo. All rights reserved.
//

import Foundation

/**
 Enum that represents the state and content of remote data. It might contain the data itself or an error or a loading state.

 It is just like a `Result` value, adding a `.loading` case to represent the initial case of "data is not loaded yet".
 This is mainly used to avoid having to use a `Result<T?, Error>`, initializing it with `.success(nil)`, and ending up with code like this:

 ```swift
 switch result {
     case let .success(value):
         if let value = value {
             // Use success value
         } else {
             // Setup loading state
         }
     case let .failure(error):
         // Deal with error
 }
 ```

 With `Loading`, the above code turns into this:

 ```swift
 switch result {
     case let .success(value):
         // Use success value
     case .loading:
         // Setup loading state
     case let .failure(error):
         // Deal with error
 }
 ```
 */
public enum Loading<Data, Failure: Error> {
    case loading
    case success(Data)
    case failure(Failure)
}

// MARK: - Computed properties

extension Loading {
    /// Whether this value is in the `.loading` state.
    public var isLoading: Bool {
        guard case .loading = self
            else { return false }
        return true
    }

    /// Whether this value is in the `.success` state.
    public var isSuccess: Bool {
        guard case .success = self
            else { return false }
        return true
    }

    /// Whether this value is in the `.failure` state.
    public var isFailure: Bool {
        guard case .failure = self
            else { return false }
        return true
    }

    /// Returns the `Data` value contained in the `.success` case, or `nil` otherwise.
    public var data: Data? {
        guard case let .success(value) = self
            else { return nil }
        return value
    }

    /// Returns the `Failure` value contained in the `.failure` case, or `nil` otherwise.
    public var error: Failure? {
        guard case let .failure(error) = self
            else { return nil }
        return error
    }
}
