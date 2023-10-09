//
//  HomeScreen.swift
//  FoodPicker
//
//  Created by atom on 2023/10/10.
//

import SwiftUI

extension HomeScreen {
    enum Tab: View, CaseIterable {
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
    @State var tab: Tab = .list

    var body: some View {
        TabView(selection: $tab) {
            ForEach(Tab.allCases, id: \.self) {
                $0
            }
        }
    }
}

#Preview {
    HomeScreen()
}
