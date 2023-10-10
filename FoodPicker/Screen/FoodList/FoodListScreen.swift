//
//  FoodListView.swift
//  FoodPicker
//
//  Created by atom on 2023/10/5.
//

import SwiftUI

struct FoodListScreen: View {
    @State private var editMode: EditMode = .inactive
    @AppStorage(.foodList) private var food = Food.examples
    @State private var selectedFoodID = Set<Food.ID>()
    @State private var mysheet: Sheet?

    var isEditing: Bool { editMode.isEditing }

    var body: some View {
        return VStack {
            titleBar

            List($food, editActions: .all, selection: $selectedFoodID, rowContent: buildFoodRow)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.groupBg2)
                        .ignoresSafeArea(.container, edges: .bottom)
                }
                .listStyle(.plain)
                .padding(.horizontal)
        }
        .background(Color.groupBg)
        // NOTE: 解决TabView子页面中 @Environment(\.editMode)失灵的问题
        .environment(\.editMode, $editMode)
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
            addButton
        }
        .padding()
    }

    var addButton: some View {
        Button {
            mysheet = .newFood { self.food.append($0) }
        } label: {
            SFSymbol.plus
                .font(.system(size: 40))
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
        removeButton
            .opacity(isEditing ? 1 : 0)
            .id(isEditing)
            .transition(.move(edge: .leading).combined(with: .opacity).animation(.easeInOut))
            .padding(.bottom)
    }

    func buildFoodRow(foodBinding: Binding<Food>) -> some View {
        let food = foodBinding.wrappedValue
        return HStack {
            Text(food.name)
                .padding(.vertical, 10)
                .font(.title3)
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
        }.listRowBackground(Color.clear)
    }
}

// MARK: Preview

#Preview {
    FoodListScreen()
}
