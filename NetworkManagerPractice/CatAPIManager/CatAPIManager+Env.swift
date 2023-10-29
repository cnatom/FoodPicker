//
//  CatAPIManager+Env.swift
//  NetworkManagerPractice
//
//  Created by atom on 2023/10/16.
//

import Foundation
import SwiftUI

/// NOTE: 自定义@Environment环境变量
struct CatAPIManagerKey: EnvironmentKey {
    static var defaultValue: CatAPIManager = .share
}

extension EnvironmentValues {
    var apiManager: CatAPIManager {
        get { self[CatAPIManagerKey.self] }
        set { self[CatAPIManagerKey.self] = newValue }
    }
}
