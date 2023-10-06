//
//  FoodListView.swift
//  FoodPicker
//
//  Created by atom on 2023/10/5.
//

import SwiftUI

struct FoodListView: View {
    @State private var food = Food.examples
    @State private var selectedFood = Set<Food.ID>()
    
    var body: some View {
        ZStack{
            Color.groupBg
                .ignoresSafeArea(.all)
            VStack {
                titleBar
                
                List($food, editActions: .all, selection: $selectedFood) { $food in
                    Text(food.name)
                }
                .listStyle(.plain)
                .padding(.horizontal)
            }
            addButton
        }
    }
}

private extension FoodListView{
    var titleBar: some View{
        HStack {
            Label("食物清单", systemImage: "fork.knife")
                .font(.title)
                .foregroundColor(.accentColor)
            
            Spacer()
            
            EditButton()
                .buttonStyle(.bordered)
        }
        .padding()
    }
    
    var addButton: some View{
        Button{
            
        }label: {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 50))
                .padding()
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, Color.accentColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    }
}

#Preview {
    FoodListView()
}
