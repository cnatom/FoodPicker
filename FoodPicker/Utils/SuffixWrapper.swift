//
//  SuffixWrapper.swift
//  FoodPicker
//
//  Created by atom on 2023/10/5.
//

import Foundation

// NOTE: 自定义propertyWrapper
// NOTE: propertyWrapper泛型
@propertyWrapper struct Suffix<Unit: MyUnitProtocol & Equatable>: Equatable {
    var wrappedValue: Double
    var unit: Unit

    init(wrappedValue: Double, _ unit: Unit) {
        self.wrappedValue = wrappedValue
        self.unit = unit
    }

    var projectedValue: Self {
        get {self}
        set {self = newValue}
    }

    var description: String {
        let preferedUnit = Unit.getPreferredUnit()
        let measurement = Measurement(value: wrappedValue, unit: unit.dimention)
        let converted = measurement.converted(to: preferedUnit.dimention)
        return converted.value.formatted(.number.precision(.fractionLength(0 ... 1))) + " \(preferedUnit.localizedSymbol)"
    }
}

// NOTE: 因为Food需要Codable，所以Food中的wrapper @Suffix 也需要是Codable的
extension Suffix: Codable {}
