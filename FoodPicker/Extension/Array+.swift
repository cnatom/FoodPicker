//
//  Array+.swift
//  FoodPicker
//
//  Created by atom on 2023/10/10.
//

import Foundation

// NOTE: 这里将Element遵循Codable的Array都遵循了RawRepresentable
// extension [Food]: RawRepresentable {
extension Array: RawRepresentable where Element: Codable {
    
    // String -> [Food]
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let array = try? JSONDecoder().decode(Self.self, from: data) else {
            return nil
        }
        self = array
    }
    
    // [Food] -> String
    public var rawValue: String {
        if let data = try? JSONEncoder().encode(self),
           let string = String(data: data, encoding: .utf8) {
            return string
        } else {
            return ""
        }
    }
}
