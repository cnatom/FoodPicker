//
//  FoodListView.swift
//  FoodPicker
//
//  Created by atom on 2023/10/5.
//

import SwiftUI

struct FoodListView: View {
    @Environment(\.editMode) var editMode
    @State private var food = Food.examples
    @State private var selectedFood = Set<Food.ID>()

    var isEditing: Bool {
        editMode?.wrappedValue == EditMode.active
    }

    var body: some View {
        VStack {
            titleBar

            List($food, editActions: .all, selection: $selectedFood) { $food in
                Text(food.name)
                    .padding(.vertical, 10)
            }
            .listStyle(.plain)
            .padding(.horizontal)
        }
        .background(Color.groupBg)
        .safeAreaInset(edge: .bottom, content: buildFloatButton)
        .sheet(isPresented: .constant(true), content: {
            let food = food.first!
            let shouldVStack = food.image.count > 1
            let layout = shouldVStack ? AnyLayout(VStackLayout(spacing: 30)) : AnyLayout(HStackLayout(spacing: 30)) // 根据内容修改排版
            
            AnyLayout.useVStack(if: shouldVStack, spacing: 30) {
                Text(food.image)
                    .font(.system(size: 100))
                    .lineLimit(1)
                    .minimumScaleFactor(0.2)
                VStack {
                    buildNutritionView(title: "热量", value: food.$calorie)
                    buildNutritionView(title: "蛋白质", value: food.$protein)
                    buildNutritionView(title: "脂肪", value: food.$fat)
                    buildNutritionView(title: "碳水", value: food.$carb)
                }
            }
            .font(.title2)
            .padding()
            .roundedRectBackground()
            .transition(.moveUpWithOpacity)
            .presentationDetents([.medium])
        })
    }
}

extension AnyLayout {
    static func useVStack(if condition: Bool, spacing: CGFloat, @ViewBuilder content: @escaping () -> some View) -> some View {
        let layout = condition ? AnyLayout(VStackLayout(spacing: spacing)) : AnyLayout(HStackLayout(spacing: spacing)) // 根据内容修改排版
        return layout(content)
    }
}

private extension FoodListView {
    func buildNutritionView(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
        .padding(.horizontal)
    }

    var titleBar: some View {
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

    var addButton: some View {
        Button {
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 50))
                .padding()
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, Color.accentColor)
        }
    }

    var removeButton: some View {
        Button {
            withAnimation {
                food = food.filter { !selectedFood.contains($0.id) }
            }
        } label: {
            Text("删除全部")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .mainButtonStyle(shape: .roundedRectangle(radius: 8))
        .padding(.horizontal, 50)
    }

    func buildFloatButton() -> some View {
        ZStack(alignment: .trailing) {
            removeButton
                .opacity(isEditing ? 1 : 0)
                .transition(.move(edge: .leading).combined(with: .opacity).animation(.easeInOut))
                .id(isEditing)
            addButton
                .opacity(isEditing ? 0 : 1)
                .transition(.scale.combined(with: .opacity).animation(.easeInOut))
                .id(isEditing)
        }
    }
}

#Preview {
    FoodListView()
}
