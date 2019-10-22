//
//  Loading.swift
//  Runes
//
//  Created by Tiziano Coroneo on 20/10/2019.
//  Copyright © 2019 Tiziano Coroneo. All rights reserved.
//

import Foundation

public enum Loading<Data, Failure: Error> {
    case success(Data)
    case loading
    case failure(Failure)

    public var isSuccess: Bool {
        guard case .success = self
            else { return false }
        return true
    }

    public var isLoading: Bool {
        guard case .loading = self
            else { return false }
        return true
    }

    public var isFailure: Bool {
        guard case .failure = self
            else { return false }
        return true
    }

    public var data: Data? {
        guard case let .success(value) = self
            else { return nil }
        return value
    }

    public var error: Failure? {
        guard case let .failure(error) = self
            else { return nil }
        return error
    }
}
