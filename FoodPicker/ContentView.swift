//
//  ContentView.swift
//  FoodPicker
//
//  Created by atom on 2023/10/5.
//

import SwiftUI

struct ContentView: View {

    @State var selectedFood: Food?

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Group{
                if selectedFood != nil {
                    Text(selectedFood!.image)
                        .font(.system(size: 250))
                        .minimumScaleFactor(0.5) // 放不下的时候缩放倍数
                        .lineLimit(1)
                        .id(selectedFood!.name)
                } else {
                    Image("dinner")
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(maxHeight: 250)

            Text("今天吃什么？")
                .fontWeight(.bold)
            
            if selectedFood != nil {
                Text(selectedFood?.name ?? "")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.accentColor)
                    .id(selectedFood?.name)
                    .transition(.asymmetric(insertion: .opacity.animation(.easeInOut), removal: .opacity.animation(.easeInOut)))
//                    .transition(.slide.combined(with: .scale))
            }
            
            Spacer()

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

            Button {
                selectedFood = nil
            } label: {
                Text("重置").frame(width: 200)
            }
        }
        .padding()
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(Color(.secondarySystemBackground))
        .font(.title)
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .controlSize(.large)
        .animation(.easeInOut, value: selectedFood)
    }
}



#Preview {
    ContentView()
}
