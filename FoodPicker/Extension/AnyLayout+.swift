//
//  AnyLayout.swift
//  FoodPicker
//
//  Created by atom on 2023/10/10.
//

import SwiftUI

extension AnyLayout {
    // NOTE: 根据内容修改排版
    static func useVStack(if condition: Bool, spacing: CGFloat, @ViewBuilder content: @escaping () -> some View) -> some View {
        let layout = condition ? AnyLayout(VStackLayout(spacing: spacing)) : AnyLayout(HStackLayout(spacing: spacing))
        return layout(content)
    }
}
