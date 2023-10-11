//
//  Unit.swift
//  FoodPicker
//
//  Created by atom on 2023/10/10.
//

import SwiftUI

protocol MyUnitProtocol: Codable,CaseIterable,Identifiable,View,RawRepresentable where RawValue == String{
    
}

extension MyUnitProtocol{
    var body: some View {
        Text(self.rawValue)
    }
}

extension MyUnitProtocol{
    var id: Self { self }
}



enum MyWeightUnit: String,MyUnitProtocol {
    case gram = "g", pound = "lb"
}

enum MyEnergyUnit:String,MyUnitProtocol{
    case cal = "大卡"
}
