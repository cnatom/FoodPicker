//
//  MyUnitProtocol.swift
//  FoodPicker
//
//  Created by atom on 2023/10/11.
//

import SwiftUI

protocol MyUnitProtocol: Codable,CaseIterable,Identifiable,View,RawRepresentable where RawValue == String,AllCases: RandomAccessCollection{
    associatedtype T: Dimension
    
    static var userDefaultsKey: UserDefaults.Key { get }
    static var defaultUnit: Self { get }
    
    var dimention: T { get }
}



extension MyUnitProtocol {
    
    // NOTE 可以不用再写 @AppStorage 了
    // [使用位置](x-source-tag://getPreferredUnit)
    static func getPreferredUnit() -> Self{
        AppStorage(userDefaultsKey).wrappedValue
    }
}

// NOTE: 通过extension为protocol添加默认实现
extension MyUnitProtocol{
    var localizedSymbol: String{
        MeasurementFormatter().string(from: dimention)
    }
    
    var body: some View {
        Text(localizedSymbol)
    }
}

extension MyUnitProtocol{
    var id: Self { self }
}

