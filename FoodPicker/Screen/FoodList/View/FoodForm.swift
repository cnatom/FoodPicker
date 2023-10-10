//
//  FoodForm.swift
//  FoodPicker
//
//  Created by atom on 2023/10/8.
//

import SwiftUI

// 用户点击键盘next之后跳转输入框
private enum MyField:Int {
    case title, image, calories, protein, fat, carb
}

private extension TextField where Label == Text{
    // NOTE: 自动更换键盘焦点
    func focused(_ field: FocusState<MyField?>.Binding,equals: MyField) -> some View{
        submitLabel(equals == .carb ? .done:.next)
            .focused(field, equals: equals)
            .onSubmit {
                field.wrappedValue = .init(rawValue: equals.rawValue + 1)
            }
    }
}

extension FoodListScreen {
    struct FoodForm: View {
        @Environment(\.dismiss) var dismiss
        @FocusState private var field: MyField?
        @State var food: Food
        
        var onSubmit: (Food)-> Void

        private var isNotValid: Bool {
            food.name.isEmpty || food.image.count > 2
        }

        private var invalidMessage: String? {
            if food.name.isEmpty { return "请输入名称" }
            if food.image.count > 2 { return "图标字数过多" }
            return nil
        }

        var body: some View {
            return NavigationView {
                VStack {
                    HStack {
                        Label("编辑食物信息", systemImage: .pencil)
                            .font(.title.bold())
                            .foregroundStyle(.accent)
                            .push(to: .leading)

                        SFSymbol.xmark
                            .font(.title.bold())
                            .foregroundStyle(.accent)
                            .onTapGesture {
                                dismiss()
                            }
                    }
                    .padding([.horizontal, .top])
                    Form {
                        LabeledContent("名称") {
                            TextField("必填", text: $food.name)
                                .focused($field, equals: .title)
                        }
                        LabeledContent("图标") {
                            TextField("最多输入两个图标", text: $food.image)
                                .focused($field, equals: .image)
                        }
                        buildNumberField(title: "热量", value: $food.calorie, suffix: "大卡",field: $field,equals: .calories)

                        buildNumberField(title: "蛋白质", value: $food.protein,field: $field,equals:.protein)

                        buildNumberField(title: "脂肪", value: $food.fat,field: $field,equals:.fat)

                        buildNumberField(title: "碳水", value: $food.carb,field: $field,equals:.carb)

                    }
                    .padding(.top, -16)
                    Button {
                        dismiss()
                        onSubmit(food)
                    } label: {
                        Text(invalidMessage ?? "保存")
                            .bold()
                            .maxWidth()
                    }
                    .mainButtonStyle()
                    .padding()
                    .disabled(isNotValid)
                }
                .background(.groupBg)
                .multilineTextAlignment(.trailing)
                .font(.title3)
                // NOTE: 取消键盘焦点
                .scrollDismissesKeyboard(.interactively)
                .toolbar(content: keyboardToolBar)
            }
        }
        
        func keyboardToolBar() -> some ToolbarContent {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(action: goPreviousField, label: {
                    SFSymbol.chevronUp
                })
                Button(action: goNextField, label: {
                    SFSymbol.chevronDown
                })
            }
        }
        
        func goPreviousField(){
            guard let rawValue = field?.rawValue else { return }
            field = .init(rawValue: rawValue - 1)
        }
        
        func goNextField(){
            guard let rawValue = field?.rawValue else { return }
            field = .init(rawValue: rawValue + 1)
        }
        
        private func buildNumberField(title: String, value: Binding<Double>, suffix: String = "g",field: FocusState<MyField?>.Binding,equals: MyField) -> some View {
            LabeledContent(title) {
                HStack {
                    TextField("", value: value, format: .number.precision(.fractionLength(1)))
                        .keyboardType(.decimalPad)
                        .focused($field, equals: equals)
                    Text(suffix)
                }
            }
        }
    }
}

#Preview {
    FoodListScreen.FoodForm(food: Food.examples.first!) { food in
        
    }
}
