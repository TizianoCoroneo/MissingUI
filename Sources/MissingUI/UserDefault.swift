//
//  UserDefault.swift
//  
//
//  Created by Tiziano Coroneo on 31/10/2019.
//

import Foundation

/**
 A propertyWrapper to handle storing values into `UserDefaults`.

 Usage:
 ```
 @UserDefault(key: UserDefaultKey.Some.count, defaultValue: 1) var key: Int
 @UserDefault(key: UserDefaultKey.SomeOther.property, defaultValue: nil) var key: Int?
 ```

 If you want to use it with a single `Key` type, you should define a `typealias`:
 ```
 typealias MyUserDefault<T> = UserDefault<T, MyKey>
 ```
 */
@propertyWrapper
public struct UserDefault<T, Key: RawRepresentable>
where Key.RawValue == String {
    public let key: Key
    public let defaultValue: T

    private let userDefaults: UserDefaults

    public init(
        key: Key,
        defaultValue: T,
        userDefaults: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    public var wrappedValue: T {
        get { getValue(forKey: key) ?? defaultValue }
        set { saveValue(forKey: key, value: newValue) }
    }

    private func saveValue(forKey key: Key, value: T) {
        if let value = value as? Int {
            userDefaults.set(value, forKey: key.rawValue)
        } else if let value = value as? Float {
            userDefaults.set(value, forKey: key.rawValue)
        } else if let value = value as? Double {
            userDefaults.set(value, forKey: key.rawValue)
        } else if let value = value as? Bool {
            userDefaults.set(value, forKey: key.rawValue)
        } else if let value = value as? URL {
            userDefaults.set(value, forKey: key.rawValue)
        } else if value is NSCoding {
            let data = NSKeyedArchiver.archivedData(withRootObject: value)
            userDefaults.set(data, forKey: key.rawValue)
        }
    }

    private func getValue(forKey key: Key) -> T? {
        if let value = userDefaults.value(forKey: key.rawValue) as? T {
            return value
        } else {
            guard let data = userDefaults.data(forKey: key.rawValue)
                else { return nil }
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? T
        }
    }
}
