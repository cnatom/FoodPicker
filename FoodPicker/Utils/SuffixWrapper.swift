//
//  SuffixWrapper.swift
//  FoodPicker
//
//  Created by atom on 2023/10/5.
//

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

