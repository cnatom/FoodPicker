//
//  FoodListView.swift
//  FoodPicker
//
//  Created by atom on 2023/10/5.
//

import SwiftUI

private enum Sheet: View, Identifiable {
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
            FoodListView.FoodForm(food: .new, onSubmit: onSubmit)
        case let .editFood(binding):
            FoodListView.FoodForm(food: binding.wrappedValue) { binding.wrappedValue = $0 }
        case let .foodDetail(food):
            FoodListView.FoodDetailSheet(food: food)
        }
    }
}

struct FoodListView: View {
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
            List($food, editActions: .all, selection: $selectedFoodID,rowContent: buildFoodRow)
            .listStyle(.plain)
        }
        .background(Color.groupBg)
        .safeAreaInset(edge: .bottom, content: buildFloatButton)
        .sheet(item: $mysheet) { $0 }
    }
}

private extension FoodListView {



    struct FoodDetailSheet: View {
        
        struct FoodDetailSheetHeightKey: PreferenceKey {
            typealias Value = CGFloat
            
            static var defaultValue: CGFloat = 0.0
            
            static func reduce(value: inout Value, nextValue: () -> Value) {
                value = nextValue()
            }
        }
        
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
            .overlay {
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: FoodDetailSheetHeightKey.self, value: proxy.size.height)
                }
            }
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

extension AnyLayout {
    static func useVStack(if condition: Bool, spacing: CGFloat, @ViewBuilder content: @escaping () -> some View) -> some View {
        let layout = condition ? AnyLayout(VStackLayout(spacing: spacing)) : AnyLayout(HStackLayout(spacing: spacing)) // 根据内容修改排版
        return layout(content)
    }
}

private extension FoodListView {
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
            mysheet = .newFood{self.food.append($0)}
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
                food = food.filter { !selectedFoodID.contains($0.id) }
            }
        } label: {
            Text("删除已选项目")
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
    
    func buildFoodRow(foodBinding: Binding<Food>) -> some View {
        let food = foodBinding.wrappedValue
        return HStack {
            Text(food.name)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle()) // 确保足够的触碰面积
                .onTapGesture {
                    if isEditing{
                        if selectedFoodID.contains(food.id){
                            selectedFoodID.remove(food.id)
                        }else{
                            selectedFoodID.insert(food.id)
                        }
                    }else{
                        mysheet = .foodDetail(food)
                    }
                }
            if isEditing {
                Image(systemName: "pencil")
                    .transition(.slide.animation(.easeInOut))
                    .onTapGesture {
                        mysheet = .editFood(foodBinding)
                    }
            }
        }
    }
}

#Preview {
    FoodListView()
}
