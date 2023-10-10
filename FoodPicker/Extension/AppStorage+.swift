//
//  AppStorage+.swift
//  FoodPicker
//
//  Created by atom on 2023/10/10.
//

import SwiftUI

extension AppStorage {
    
    // NOTE: 自定义AppStorage的propertyWrapper的init
    init(wrappedValue: Value, _ key: UserDefaults.Key, store: UserDefaults? = nil) where Value == Bool {
        self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }
    
    init(wrappedValue: Value, _ key: UserDefaults.Key, store: UserDefaults? = nil) where Value: RawRepresentable, Value.RawValue == String {
        self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }
}
