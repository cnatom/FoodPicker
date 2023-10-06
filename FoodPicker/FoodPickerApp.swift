//
//  FoodPickerApp.swift
//  FoodPicker
//
//  Created by atom on 2023/10/5.
// 
// 【3-3 实作食物清单 List、悬浮按钮、AnyLayout - Swift 新手入门】 【精准空降到 26:49】 https://www.bilibili.com/video/BV1aW4y1T7tg/?p=13&share_source=copy_web&vd_source=bddae006d79b0c34f994f76cddd065c3&t=1609

import SwiftUI

@main
struct FoodPickerApp: App {
    var body: some Scene {
        WindowGroup {
            FoodListView()
        }
    }
}
