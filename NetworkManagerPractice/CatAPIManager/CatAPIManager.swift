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
    var getData: (Endpoint) async throws -> Data

    /// NOTE: 同一个类中两种不同的单例
    /// - share: 网络请求
    /// - stub:  用于测试&preview
    /// [example](x-source-tag://testGetImages)
    static let share: CatAPIManager = {
        /// NOTE: 为Session添加全局header
        let config = URLSessionConfiguration.default
        var headers = config.httpAdditionalHeaders ?? [:]
        headers["x-api-key"] = MySecret.apiKey
        config.httpAdditionalHeaders = headers

        let session = URLSession(configuration: config)
        return CatAPIManager { endPoint in
            try await session.data(for: endPoint.request) // 真正发送网络请求的地方
        }
    }()

    static let stub = CatAPIManager { endPoint in
        endPoint.stub
    }

    private init(getData: @escaping (Endpoint) async throws -> Data) {
        self.getData = getData
    }
}

// MARK: - Get
extension CatAPIManager {
    func getImages() async throws -> [ImageResponse] {
        try await fetch(endPoint: .images)
    }

    func getFavorite() async throws -> [FavoriteItem]{
        try await fetch(endPoint: .favorites)
    }

    func addToFavorite(imageID: String) async throws -> Int {
        let body = ["image_id": imageID]
        let bodyData = try JSONSerialization.data(withJSONObject: body)
        let response: FavoriteCreationResponse = try await fetch(endPoint: .addToFavorite(bodyData: bodyData))
        return response.id
    }
    
    func removeFromfavorite(id: Int)async throws{
        let _ = try await getData(.removeFromFavorite(id: id))

    }
}

// MARK: Fetch
private extension CatAPIManager {
    func fetch<T: Decodable>(endPoint: Endpoint)async throws -> T {
        let data = try await getData(endPoint)
        
        /// NOTE: 自定义JSONDecoder解析日期的方式
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return try decoder.decode(T.self, from: data)
    }
}

// MARK: Response Bean
extension CatAPIManager {
    struct ImageResponse: Decodable {
        let id: String
        let url: URL
        let width, height: CGFloat
    }

    struct FavoriteCreationResponse: Decodable {
        let id: Int
    }
    
    
}

extension CatAPIManager {
    // 用来包裹两种网络请求的request
    enum Endpoint {
        case images
        case addToFavorite(bodyData: Data)
        case favorites
        case removeFromFavorite(id: Int)

        var request: URLRequest {
            switch self {
                
            case .images:
                return URLRequest(url: "https://api.thecatapi.com/v1/images/search?limit=10")
                
            case .addToFavorite(let bodyData):
                var urlRequest = URLRequest(url: "https://api.thecatapi.com/v1/favourites")
                urlRequest.httpMethod = "POST"
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = bodyData
                return urlRequest
                
            case .favorites:
                /// TODO: 新增页面参数
                return URLRequest(url: "https://api.thecatapi.com/v1/favourites")
                
            case .removeFromFavorite(let id):
                var urlRequest = URLRequest(url: URL(string: "https://api.thecatapi.com/v1/favourites/\(id)")!)
                
                urlRequest.httpMethod = "DELETE"
                return urlRequest
            }
        }
    }
}
