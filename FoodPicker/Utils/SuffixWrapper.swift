//
//  SuffixWrapper.swift
//  FoodPicker
//
//  Created by atom on 2023/10/5.
//

// NOTE: 自定义propertyWrapper
@propertyWrapper struct Suffix<Unit: MyUnitProtocol & Equatable>: Equatable {
    var wrappedValue: Double
    private let unit: Unit

    init(wrappedValue: Double, _ unit: Unit) {
        self.wrappedValue = wrappedValue
        self.unit = unit
    }

    var projectedValue: Self {
        self
    }

    var description: String {
        wrappedValue.formatted(.number.precision(.fractionLength(0 ... 1))) + " \(unit.rawValue)"
    }
}

// NOTE: 因为Food需要Codable，所以Food中的wrapper @Suffix 也需要是Codable的
extension Suffix: Codable {}
