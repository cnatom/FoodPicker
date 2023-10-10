//
//  SettingScreen.swift
//  FoodPicker
//
//  Created by atom on 2023/10/10.
//

import SwiftUI

struct SettingScreen: View {
    @AppStorage(.shouldUseDarkMode) private var shouldUseDarkMode: Bool = false
    @AppStorage(.unit) private var unit: Unit = .gram
    @AppStorage(.startTab) private var startTab: HomeScreen.Tab = .picker
    @State private var confirmationDialog: Dialog = .inactive

    private var shouldShowDialog: Binding<Bool> {
        // NOTE: 自定义Binding的set、get
        Binding {
            confirmationDialog != .inactive
        } set: { _ in confirmationDialog = .inactive }
    }

    var body: some View {
        Form {
            Section("基本设置") {
                Toggle(isOn: $shouldUseDarkMode) {
                    Label("深色模式", systemImage: .moon)
                }

                Picker(selection: $unit) {
                    ForEach(Unit.allCases) { $0.tag($0) }
                } label: {
                    Label("单位", systemImage: .unitSign)
                }

                Picker(selection: $startTab) {
                    Text("随机食物").tag(HomeScreen.Tab.picker)
                    Text("食物清单").tag(HomeScreen.Tab.list)
                } label: {
                    Label("启动画面", systemImage: .house)
                }
            }
            Section("危险设置") {
                ForEach(Dialog.allCases) { dialog in
                    Button(dialog.rawValue) {
                        confirmationDialog = dialog
                    }
                    .tint(Color(.label))
                }
            }
            .confirmationDialog(confirmationDialog.rawValue, isPresented: shouldShowDialog) {
                Button("确定", role: .destructive,action: confirmationDialog.action)
                Button("取消", role: .cancel,action: confirmationDialog.action)
            } message: {
                Text(confirmationDialog.message)
            }
        }
    }
}

enum Dialog: String {
    case resetSettings = "恢复默认设置"
    case resetFoodList = "重置食物记录"
    case inactive // 不显示Dialog

    var message: String {
        switch self {
        case .resetSettings:
            return "将重置颜色、单位等设置，\n此操作无法复原，确定进行吗？"
        case .resetFoodList:
            return "将重置食物清单，\n此操作无法复原，确定进行吗？"
        case .inactive:
            return ""
        }
    }
    
    func action(){
        switch self {
        case .resetSettings:
            let keys: [UserDefaults.Key] = [.shouldUseDarkMode, .unit,.startTab]
            for key in keys{
                UserDefaults.standard.removeObject(forKey: key.rawValue)
            }
        case .resetFoodList:
            UserDefaults.standard.removeObject(forKey: UserDefaults.Key.foodList.rawValue)
        case .inactive:
            return
        }
    }
}

extension Dialog: CaseIterable {
    static let allCases: [Dialog] = [.resetSettings, .resetFoodList]
}

extension Dialog: Identifiable {
    var id: Self { self }
}

#Preview {
    SettingScreen()
}
