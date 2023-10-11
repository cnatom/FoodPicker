//
//  Food.swift
//  FoodPicker
//
//  Created by atom on 2023/10/5.
//

import Foundation
import SwiftUI

struct Food: Equatable, Identifiable {
    // NOTE: 因为需要解码之后给Food内的属性赋值，因此这里需要是var，而不是let
    // let id = UUID()
    var id = UUID()

    var name: String
    var image: String

    @Suffix<MyEnergyUnit> var calorie: Double
    @Suffix<MyWeightUnit> var carb: Double
    @Suffix<MyWeightUnit> var fat: Double
    @Suffix<MyWeightUnit> var protein: Double
}

// MARK: statics

extension Food {
    private init(name: String, image: String, calorie: Double, carb: Double, fat: Double, protein: Double,energyUnit: MyEnergyUnit = .cal, weightUnit: MyWeightUnit = .gram) {
        self.name = name
        self.image = image
        _calorie = .init(wrappedValue: calorie, energyUnit)
        _carb = .init(wrappedValue: carb, weightUnit)
        _fat = .init(wrappedValue: fat, weightUnit)
        _protein = .init(wrappedValue: protein, weightUnit)
    }

    static let examples = [
        Food(name: "汉堡", image: "🍔", calorie: 294, carb: 14, fat: 24, protein: 17),
        Food(name: "沙拉", image: "🥗", calorie: 89, carb: 20, fat: 0, protein: 1.8),
        Food(name: "披萨", image: "🍕", calorie: 266, carb: 33, fat: 10, protein: 11),
        Food(name: "意大利面", image: "🍝", calorie: 339, carb: 74, fat: 1.1, protein: 12),
        Food(name: "鸡腿便当", image: "🍗🍱", calorie: 191, carb: 19, fat: 8.1, protein: 11.7),
        Food(name: "刀削面", image: "🍜", calorie: 256, carb: 56, fat: 1, protein: 8),
        Food(name: "火锅", image: "🍲", calorie: 233, carb: 26.5, fat: 17, protein: 22),
        Food(name: "牛肉面", image: "🐄🍜", calorie: 219, carb: 33, fat: 5, protein: 9),
        Food(name: "关东煮", image: "🥘", calorie: 80, carb: 4, fat: 4, protein: 6),
    ]

    static var new: Food {
        @AppStorage(.perferredEnergyUnit) var energyUnit: MyEnergyUnit = .cal
        @AppStorage(.perferredWeightUnit) var weightUnit: MyWeightUnit = .gram
        return Food(name: "", image: "", calorie: 0.0, carb: 0.0, fat: 0.0, protein: 0.0,energyUnit: energyUnit,weightUnit: weightUnit)
    }
}

extension Food: Codable {
}
