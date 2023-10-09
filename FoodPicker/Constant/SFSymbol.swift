//
//  SFSymbol.swift
//  FoodPicker
//
//  Created by atom on 2023/10/9.
//

import Foundation
import SwiftUI

enum SFSymbol: String {
    case pencil
    case plus = "plus.circle.fill"
    case chevronUp = "chevron.up"
    case chevronDown = "chevron.down"
    case xmark = "xmark.circle.fill"
    case forkAndKnife = "fork.knife"
    case info = "info.circle.fill"
    case moon = "moon.fill"
    case unitSign = "numbersign"
    case house = "house.fill"
    case list = "list.bullet"
    case gear = "gearshape"
}

extension SFSymbol: View {
    var body: Image {
        Image(systemName: rawValue)
    }

    func resizable() -> Image {
        body.resizable()
    }
}

// extension Image{
//
//    init(systemName: SFSymbol){
//        self.init(systemName: systemName.rawValue)
//    }
// }

extension Label where Title == Text, Icon == Image {
    init(_ text: String, systemImage: SFSymbol) {
        self.init(text,
                  systemImage: systemImage.rawValue)
    }
}
