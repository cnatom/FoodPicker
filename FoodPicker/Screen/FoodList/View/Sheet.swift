//
//  Sheet.swift
//  FoodPicker
//
//  Created by atom on 2023/10/9.
//

import SwiftUI

extension FoodListScreen {
    enum Sheet: View, Identifiable {
        case newFood((Food) -> Void)
        case editFood(Binding<Food>)
        case foodDetail(Food)

        //    var id: UUID { UUID() }

        var id: UUID {
            switch self {
            case .newFood:
                return UUID()
            case let .editFood(binding):
                return binding.wrappedValue.id
            case let .foodDetail(food):
                return food.id
            }
        }

        var body: some View {
            switch self {
            case let .newFood(onSubmit):
                FoodForm(food: .new, onSubmit: onSubmit)
            case let .editFood(binding):
                FoodForm(food: binding.wrappedValue) { binding.wrappedValue = $0 }
            case let .foodDetail(food):
                FoodDetailSheet(food: food)
            }
        }
    }
}
