//
//  URL+.swift
//  NetworkManagerPractice
//
//  Created by Jane Chao on 2023/4/1.
//

import Foundation

extension URL: ExpressibleByStringLiteral {
    /// NOTE: StaticString
    /// - URL("http://www.xxxx.com")，双引号扩起来的String即为StaticString类型
    public init(stringLiteral value: StaticString) {
        self.init(string: value.description)!
    }
}
