//
//  CatAPIManager.swift
//  NetworkManagerPractice
//
//  Created by atom on 2023/10/16.
//

import Foundation

final class CatAPIManager {
    
    /// NOTE: 网络数据技巧 for 单元测试 & preview
    /// - 单元测试：可以修改获取Data的方式从网络->本地，从而可以单独的测试JSONDecoder
    /// - preview：getData通过调用本地的数据，可以实现快速预览
    var getData: (URLRequest) async throws -> Data

    /// NOTE: 同一个类中两种不同的单例
    /// - share: 网络请求
    /// - stub:  用于测试&preview
    /// [example](x-source-tag://testGetImages)
    static let share: CatAPIManager = {
        let session = URLSession(configuration: .default)
        return CatAPIManager(getData: session.data)
    }()

    static let stub = CatAPIManager { _ in
        Data(
            """
            [{"id":"297","url":"https://cdn2.thecatapi.com/images/297.jpg","width":1632,"height":1224},{"id":"9og","url":"https://cdn2.thecatapi.com/images/9og.jpg","width":1024,"height":765},{"id":"b41","url":"https://cdn2.thecatapi.com/images/b41.jpg","width":400,"height":600},{"id":"b8v","url":"https://cdn2.thecatapi.com/images/b8v.jpg","width":500,"height":308},{"id":"co7","url":"https://cdn2.thecatapi.com/images/co7.jpg","width":500,"height":637},{"id":"cp5","url":"https://cdn2.thecatapi.com/images/cp5.jpg","width":600,"height":453},{"id":"d03","url":"https://cdn2.thecatapi.com/images/d03.jpg","width":2572,"height":1819},{"id":"e35","url":"https://cdn2.thecatapi.com/images/e35.jpg","width":400,"height":660},{"id":"egn","url":"https://cdn2.thecatapi.com/images/egn.jpg","width":500,"height":667},{"id":"MTU4MDMzNg","url":"https://cdn2.thecatapi.com/images/MTU4MDMzNg.jpg","width":1161,"height":1280}]
            """.utf8)
    }

    private init(getData: @escaping (URLRequest) async throws -> Data) {
        self.getData = getData
    }
}

extension CatAPIManager {
    func getImages() async throws -> [ImageResponse] {
        let data = try await getData(URLRequest(url: "https://api.thecatapi.com/v1/images/search?limit=10"))
        let res = try JSONDecoder().decode([ImageResponse].self, from: data)
        return res
    }
}

extension CatAPIManager {
    struct ImageResponse: Decodable {
        let id: String
        let url: URL
        let width, height: CGFloat
    }
}
