//
//  Task+.swift
//  NetworkManagerPractice
//
//  Created by atom on 2023/10/28.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    ///  try await Task.sleep(seconds:1) 等待一秒
    /// - Parameter seconds: 秒
    public static func sleep(seconds: UInt64) async throws {
        let duration = UInt64(seconds * 1000000000)
        try await Task.sleep(nanoseconds: duration)
    }
}
