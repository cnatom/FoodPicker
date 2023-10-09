//
//  FoodListView.swift
//  FoodPicker
//
//  Created by atom on 2023/10/5.
//

import SwiftUI

struct FoodListScreen: View {
    @Environment(\.editMode) var editMode
    @State private var food = Food.examples
    @State private var selectedFoodID = Set<Food.ID>()

    @State private var mysheet: Sheet?

    var isEditing: Bool {
        editMode?.wrappedValue == EditMode.active
    }

    var body: some View {
        VStack {
            titleBar
            List($food, editActions: .all, selection: $selectedFoodID, rowContent: buildFoodRow)
                .listStyle(.plain)
        }
        .background(Color.groupBg)
        .safeAreaInset(edge: .bottom, content: buildFloatButton)
        .sheet(item: $mysheet)
    }
}

// MARK: SubView

private extension FoodListScreen {
    var titleBar: some View {
        HStack {
            Label("食物清单", systemImage: SFSymbol.forkAndKnife)
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
            mysheet = .newFood { self.food.append($0) }
        } label: {
            SFSymbol.plus
                .font(.system(size: 50))
                .padding()
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, Color.accentColor)
        }
    }

    var removeButton: some View {
        Button {
            withAnimation {
                food = food.filter { !selectedFoodID.contains($0.id) }
            }
        } label: {
            Text("删除已选项目")
                .font(.title2.bold())
                .maxWidth()
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

    func buildFoodRow(foodBinding: Binding<Food>) -> some View {
        let food = foodBinding.wrappedValue
        return HStack {
            Text(food.name)
                .padding(.vertical, 10)
                .push(to: .leading)
                .contentShape(Rectangle()) // 确保足够的触碰面积
                .onTapGesture {
                    if isEditing {
                        if selectedFoodID.contains(food.id) {
                            selectedFoodID.remove(food.id)
                        } else {
                            selectedFoodID.insert(food.id)
                        }
                    } else {
                        mysheet = .foodDetail(food)
                    }
                }
            if isEditing {
                SFSymbol.pencil
                    .transition(.slide.animation(.easeInOut))
                    .onTapGesture {
                        mysheet = .editFood(foodBinding)
                    }
            }
        }
    }
}

// MARK: Preview

#Preview {
    FoodListScreen()
}
