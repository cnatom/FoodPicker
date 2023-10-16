//
//  NetworkManagerPracticeTests.swift
//  NetworkManagerPracticeTests
//
//  Created by atom on 2023/10/16.
//

import XCTest
@testable import NetworkManagerPractice

final class NetworkManagerPracticeTests: XCTestCase {
    
    /// - Tag: testGetImages
    let sut = CatAPIManager.stub
    
    func testGetImages()async throws {
        let images = try await sut.getImages()
        XCTAssertEqual(images.count, 10)
    }

}
