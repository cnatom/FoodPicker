//
//  HomeScreen.swift
//  FoodPicker
//
//  Created by atom on 2023/10/10.
//

import SwiftUI

extension HomeScreen {
    // NOTE: enum的Tab
    enum Tab: String, View, CaseIterable, Identifiable{
        var id: Self { self}
        
        case picker, list, settings
        
        

        var body: some View {
            content.tabItem { tabLabel }
        }

        @ViewBuilder
        private var content: some View {
            switch self {
            case .picker: FoodPickerScreen()
            case .list: FoodListScreen()
            case .settings: SettingScreen()
            }
        }

        private var tabLabel: some View {
            switch self {
            case .picker:
                return Label("Home", systemImage: .house)
            case .list:
                return Label("List", systemImage: .list)
            case .settings:
                return Label("Settings", systemImage: .gear)
            }
        }
    }
}

struct HomeScreen: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage(.shouldUseDarkMode) var shouldUseDarkMode = false
    @State var tab: Tab = {
        // NOTE: 手动读取UserDefaults中的本地数据
        let rawValue = UserDefaults.standard.string(forKey: UserDefaults.Key.startTab.rawValue) ?? ""
        return Tab(rawValue: rawValue) ?? .picker
//        @AppStorage(.startTab) var tab = HomeScreen.Tab.picker
//        return tab
    }()

    var body: some View {
        NavigationView {
            TabView(selection: $tab) {
                ForEach(Tab.allCases) {
                    $0
                }
            }
            .preferredColorScheme(shouldUseDarkMode ? .dark : .light)
        }
    }
}

#Preview {
    HomeScreen()
}
