//
//  FoodDetailSheet.swift
//  FoodPicker
//
//  Created by atom on 2023/10/9.
//

import SwiftUI

extension FoodListScreen {
    
    private struct FoodDetailSheetHeightKey: PreferenceKey {
        typealias Value = CGFloat
        static var defaultValue: CGFloat = 0.0
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value = nextValue()
        }
    }
    
    struct FoodDetailSheet: View {
        
        @State private var foodDetailHeight: CGFloat = FoodDetailSheetHeightKey.defaultValue
        
        var food: Food
        
        var body: some View {
            let shouldVStack = food.image.count > 1
            
            AnyLayout.useVStack(if: shouldVStack, spacing: 20) {
                Text(food.image)
                    .font(.system(size: 100))
                    .lineLimit(1)
                    .minimumScaleFactor(shouldVStack ? 1 : 0.2)
                
                VStack(spacing: 10) {
                    buildNutritionView(title: "热量", value: food.$calorie)
                    buildNutritionView(title: "蛋白质", value: food.$protein)
                    buildNutritionView(title: "脂肪", value: food.$fat)
                    buildNutritionView(title: "碳水", value: food.$carb)
                }
            }
            .padding()
            .readGeometry(\.size.height,key: FoodDetailSheetHeightKey.self)
            .roundedRectBackground()
            .transition(.moveUpWithOpacity)
            .presentationDetents([.height(foodDetailHeight)])
            .onPreferenceChange(FoodDetailSheetHeightKey.self, perform: { value in
                foodDetailHeight = value
            })
        }
        
        func buildNutritionView(title: String, value: String) -> some View {
            HStack {
                Text(title)
                Spacer()
                Text(value)
            }
            .padding(.horizontal, 30)
        }
    }
}

extension View{
    
    func readGeometry<K:PreferenceKey,Value>(_ keyPath: KeyPath<GeometryProxy,Value>,key: K.Type) -> some View where K.Value == Value{
        overlay {
            GeometryReader { proxy in
                Color.clear
                    .preference(key: key, 
                                value: proxy[keyPath: keyPath])
            }
        }
    }
    
}
