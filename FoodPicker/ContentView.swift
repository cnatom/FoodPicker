//
//  ContentView.swift
//  FoodPicker
//
//  Created by atom on 2023/10/5.
//

import SwiftUI

struct ContentView: View {
    let food = ["汉堡","沙拉","披萨","意大利面","鸡腿便当","刀削面","火锅","牛肉面","关东煮"]
    @State var selectedFood: String?
    var body: some View {
        VStack(spacing:20) {
            Image("dinner")
                .resizable()
                .scaledToFit()
            
            Text("今天吃什么？")
                .fontWeight(.bold)
            
            if selectedFood != nil {
                Text(selectedFood ?? "")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.accentColor)
                    .id(selectedFood)
                    .transition(.asymmetric(insertion: .opacity.animation(.easeInOut), removal: .opacity.animation(.easeInOut)))
//                    .transition(.slide.combined(with: .scale))
            }

            Button{
//                withAnimation {
//                    selectedFood = food.shuffled().first{$0 != selectedFood}
//                }
                selectedFood = food.shuffled().first{$0 != selectedFood}
            } label: {
                Text(selectedFood == nil ? "告诉我" : "换一个")
                    .frame(width: 200)
                    .transformEffect(.identity)
            }
            .buttonStyle(.borderedProminent)

            Button{
                selectedFood = nil
            }label: {
                Text("重置").frame(width: 200)
            }

        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(Color(.secondarySystemBackground))
        .font(.title)
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .controlSize(.large)
        .animation(.easeInOut,value: selectedFood)
    }
}

#Preview {
    ContentView()
}
