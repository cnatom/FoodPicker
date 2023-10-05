//
//  Extensions.swift
//  FoodPicker
//
//  Created by atom on 2023/10/5.
//

import SwiftUI


extension View {
    func mainButtonStyle() -> some View {
        buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
    }
    
    func roundedRectBackground(radius: CGFloat = 8,color: Color = Color.bg) -> some View {
        background(RoundedRectangle(cornerRadius: radius).foregroundColor(color))
    }
}

extension Animation {
    static let mySpring = Animation.spring(dampingFraction: 0.55)
    static let myEase = Animation.easeInOut(duration: 0.6)
}

extension Color {
    static let bg = Color(.systemBackground)
    static let bg2 = Color(.secondarySystemBackground)
}

extension AnyTransition {
    static let delayInsertionOpacity = Self.asymmetric(
        insertion: .opacity.animation(.easeInOut(duration: 0.5).delay(0.2)),
        removal: .opacity.animation(.easeInOut(duration: 0.4)))
    static let moveUpWithOpacity = Self.move(edge: .top).combined(with: .opacity)
}
