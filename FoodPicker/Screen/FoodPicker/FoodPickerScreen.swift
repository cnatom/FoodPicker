//
//  ContentView.swift
//  FoodPicker
//
//  Created by atom on 2023/10/5.
//

import SwiftUI


struct FoodPickerScreen: View {
    @State private var selectedFood: Food?
    @State private var shouldShowInfo: Bool = false

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 20) {
                foodImage
                
                Text("今天吃什么？").font(.title.bold())
                
                selectedFoodInfoView
                
                Spacer()
                
                selectFoodButton
                
                cancelButton
            }
            .padding()
            .maxWidth()
            .frame(minHeight: proxy.size.height)
            .font(.title2)
            .mainButtonStyle()
            .animation(.mySpring, value: shouldShowInfo)
            .animation(.myEase, value: selectedFood)
            .background(Color.bg2)
        }
    }
}

// MARK: - Subviews

private extension FoodPickerScreen {
    var foodImage: some View {
        Group {
            if let selectedFood {
                Text(selectedFood.image)
                    .font(.system(size: 250))
                    .minimumScaleFactor(0.5) // 放不下的时候缩放倍数
                    .lineLimit(1)
                    .id(selectedFood.name)
            } else {
                Image("dinner")
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(height: 250)
    }

    @ViewBuilder var selectedFoodInfoView: some View {
        if let selectedFood {
            HStack {
                Text(selectedFood.name)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.accentColor)
                    .id(selectedFood.name)
                    .transition(.delayInsertionOpacity)
                //                    .transition(.slide.combined(with: .scale))
                Button {
                    shouldShowInfo.toggle()
                } label: {
                    SFSymbol.info
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            Text("热量 \(selectedFood.$calorie.description)")

            selectedFoodDetailInfoView
        }
    }
    
    var selectedFoodDetailInfoView: some View{
        VStack {
            if shouldShowInfo {
                HStack {
                 
                    buildElementColumn(title: "蛋白质", subTitle: selectedFood!.$protein.description)
                    
                    Divider().frame(width: 1, height: 30).padding(.horizontal)
                    
                    buildElementColumn(title: "脂肪", subTitle: selectedFood!.$fat.description)

                    
                    Divider().frame(width: 1, height: 30).padding(.horizontal)
                    
                    buildElementColumn(title: "碳水", subTitle: selectedFood!.$carb.description)

                }
                .font(.title2)
                .padding()
                .roundedRectBackground()
                .transition(.moveUpWithOpacity)
            }
        }
        .maxWidth()
        .clipped() // 动画开始时防止与上方view重叠
    }
    
    func buildElementColumn(title: String,subTitle: String) -> some View{
        VStack(spacing: 12) {
            Text(title)
            Text(subTitle)
                .lineLimit(1)
        }
        .minimumScaleFactor(0.3)
    }

    var selectFoodButton: some View {
        Button {
            //                withAnimation {
            //                    selectedFood = food.shuffled().first{$0 != selectedFood}
            //                }
            selectedFood = Food.examples.shuffled().first { $0 != selectedFood }
        } label: {
            Text(selectedFood == nil ? "告诉我" : "换一个")
                .frame(width: 200)
                .transformEffect(.identity)
        }
        .buttonStyle(.borderedProminent)
    }

    var cancelButton: some View {
        Button {
            selectedFood = nil
            shouldShowInfo = false
        } label: {
            Text("重置").frame(width: 200)
        }
        .buttonStyle(.bordered)
    }
}

extension FoodPickerScreen {
    init(selectedFood: Food) {
        _selectedFood = .init(wrappedValue: selectedFood)
    }
}

#Preview {
    FoodPickerScreen()
}
