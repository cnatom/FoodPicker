//
//  View+.swift
//  FoodPicker
//
//  Created by atom on 2023/10/10.
//

import SwiftUI

extension View {
    func mainButtonStyle(shape: ButtonBorderShape = .capsule) -> some View {
        buttonStyle(.borderedProminent)
            .buttonBorderShape(shape)
            .controlSize(.large)
    }
    
    func roundedRectBackground(radius: CGFloat = 8, color: Color = Color.bg) -> some View {
        background(RoundedRectangle(cornerRadius: radius).foregroundColor(color))
    }
    
    func testBG() -> some View {
        background {
            Color.green
        }
    }
    
    func sheet(item: Binding<(some View & Identifiable)?>) -> some View{
        sheet(item: item) { $0 }
    }
    
    /// - Tag: push
    func push(to alignment: TextAlignment) -> some View{
        switch alignment {
        case .leading:
            return frame(maxWidth: .infinity,alignment: .leading)
        case .center:
            return frame(maxWidth: .infinity,alignment: .center)
        case .trailing:
            return frame(maxWidth: .infinity,alignment: .trailing)
        }
    }
    // NOTE: 给文档加链接
    /// Shortcut: [push(to: .center)](x-source-tag://push)
    func maxWidth() -> some View{
        push(to: .center)
    }
}
