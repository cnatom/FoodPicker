//
//  Unit.swift
//  FoodPicker
//
//  Created by atom on 2023/10/10.
//

import SwiftUI


enum MyWeightUnit: String,MyUnitProtocol {
    case gram = "g", pound = "lb", ounce

    static var userDefaultsKey: UserDefaults.Key = .perferredWeightUnit
    
    static var defaultUnit: MyWeightUnit = .gram
    
    
    var dimention: UnitMass{
        switch self {
        case .gram:
            return .grams
        case .pound:
            return .pounds
        case .ounce:
            return .ounces
        }
    }
}

enum MyEnergyUnit:String,MyUnitProtocol{
    static var userDefaultsKey: UserDefaults.Key = .perferredEnergyUnit
    
    static var defaultUnit: MyEnergyUnit = .cal
    
    case cal = "大卡"
    
    var dimention: UnitEnergy{
        switch self {
        case .cal:
            return .calories
        }
    }
}

