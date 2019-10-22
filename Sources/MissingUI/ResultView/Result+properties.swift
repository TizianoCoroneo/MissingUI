//
//  Result+properties.swift
//  
//
//  Created by Tiziano Coroneo on 22/10/2019.
//

import Foundation

/**
 Utilities to deal with `Result`inside `@ViewBuilder` closures.
 Since "function builders"  do not support yet other flow control statements other than plain `if`s, we cannot use `switch` on `Result` values.

 A (ugly) workaround is to use the following extension and do something like this instead:

 ```swift
 VStack {
   if result.isSuccess {
     Text("Value: \(result.value!)")
   } else {
     Text("Error: \(result.error!)")
   }
 }
 ```

 Otherwise, you can use `ResultView`:

 ```swift
 ResultView(
   result,
   successView: { value in
     Text("Value: \(value)")
   }, failureView: { error in
     Text("Error: \(error)")
 })
 ```
 */
extension Result {

    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }

    var isFailure: Bool {
        switch self {
        case .success: return false
        case .failure: return true
        }
    }

    var value: Success? {
        switch self {
        case .success(let value): return value
        case .failure: return nil
        }
    }

    var error: Failure? {
        switch self {
        case .failure(let error): return error
        case .success: return nil
        }
    }
}
