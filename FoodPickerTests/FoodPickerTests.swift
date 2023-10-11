//
//  FoodPickerTests.swift
//  FoodPickerTests
//
//  Created by atom on 2023/10/10.
//

import XCTest

// NOTE: testable- Introducing members in FoodPicker
@testable import FoodPicker

final class SuffixTests: XCTestCase {
    
    var sut: Suffix!
    
    // test_formattedString_suffixIsEmpty_shouldNotIncludeSpace
    
    func testMeasure(){
        let m : Measurement = .init(value: 100.0, unit: .init(symbol: "g"))
        print(m.description)
    }
    
    func testFormatter() {
        
//        sut = .init(wrappedValue: 100, "")
//        XCTAssertEqual(sut.projectedValue, "100")
//        
//        sut = .init(wrappedValue: 100.123, "大卡")
//        XCTAssertEqual(sut.projectedValue, "100.1 大卡")
//        
    }

}
