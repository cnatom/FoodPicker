//
//  NetworkManagerPracticeApp.swift
//  NetworkManagerPractice
//
//  Created by atom on 2023/10/14.
// 【6-6 串接 API：POST 请求 & 解析日期 - SwiftUI 新手入门】 【精准空降到 12:30】 https://www.bilibili.com/video/BV1No4y1u7Nx/?share_source=copy_web&vd_source=bddae006d79b0c34f994f76cddd065c3&t=750

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
