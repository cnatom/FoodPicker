//
//  NetworkManagerPracticeApp.swift
//  NetworkManagerPractice
//
//  Created by atom on 2023/10/14.
//

import SwiftUI

@main
struct AppEntry: App {
    init(){
        applyTabBarBackground()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeScreen()
        }
    }
}


extension AppEntry {
    func applyTabBarBackground(){
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundColor = .systemBackground.withAlphaComponent(0.3)
        tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
