//
//  Unit.swift
//  FoodPicker
//
//  Created by atom on 2023/10/10.
//

import SwiftUI

enum Unit: String, CaseIterable, Identifiable, View {
    case gram = "g", pound = "lb"
    var id: String { rawValue }
    
    var body: some View {
        Text(self.rawValue)
    }
}
