//
//  UserDefaultEnum.swift
//  AutoNewsFeed
//
//  Created by Roman Gornostayev on 11.07.2025.
//

import Foundation

@propertyWrapper
public struct UserDefaultEnum<Value: RawRepresentable> where Value.RawValue == String {
  private let key: String
  private let defaultValue: Value
  private let storage: UserDefaults
  
  public init(key: String, defaultValue: Value, storage: UserDefaults = .standard) {
    self.key = key
    self.defaultValue = defaultValue
    self.storage = storage
  }
  
  public var wrappedValue: Value {
    get {
      guard let rawValue = storage.string(forKey: key),
            let value = Value(rawValue: rawValue) else {
        return defaultValue
      }
      return value
    }
    set {
      storage.set(newValue.rawValue, forKey: key)
    }
  }
}
