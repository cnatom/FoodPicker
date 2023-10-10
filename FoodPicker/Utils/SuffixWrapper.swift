//
//  SuffixWrapper.swift
//  FoodPicker
//
//  Created by atom on 2023/10/5.
//

// NOTE: 自定义propertyWrapper
@propertyWrapper struct Suffix: Equatable{
    var wrappedValue: Double
    private let suffix: String
    
    init(wrappedValue: Double,_ suffix: String) {
        self.wrappedValue = wrappedValue
        self.suffix = suffix
    }
    
    var projectedValue: String{
        String(format: "%.1f \(suffix)", wrappedValue)
    }
    
}

// NOTE: 因为Food需要Codable，所以Food中的wrapper @Suffix 也需要是Codable的
extension Suffix: Codable{
    
}

