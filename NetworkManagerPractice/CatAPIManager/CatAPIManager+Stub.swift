//
//  CatAPIManager+Stub.swift
//  NetworkManagerPractice
//
//  Created by atom on 2023/10/17.
//

import Foundation

extension CatAPIManager.Endpoint {
    /// NOTE: 为每个网络请求设定默认的假回传
    var stub: Data {
        let string: String
        switch self {
        case .images:
            string = """
            [{"id":"297","url":"https://cdn2.thecatapi.com/images/297.jpg","width":1632,"height":1224},{"id":"9og","url":"https://cdn2.thecatapi.com/images/9og.jpg","width":1024,"height":765},{"id":"b41","url":"https://cdn2.thecatapi.com/images/b41.jpg","width":400,"height":600},{"id":"b8v","url":"https://cdn2.thecatapi.com/images/b8v.jpg","width":500,"height":308},{"id":"co7","url":"https://cdn2.thecatapi.com/images/co7.jpg","width":500,"height":637},{"id":"cp5","url":"https://cdn2.thecatapi.com/images/cp5.jpg","width":600,"height":453},{"id":"d03","url":"https://cdn2.thecatapi.com/images/d03.jpg","width":2572,"height":1819},{"id":"e35","url":"https://cdn2.thecatapi.com/images/e35.jpg","width":400,"height":660},{"id":"egn","url":"https://cdn2.thecatapi.com/images/egn.jpg","width":500,"height":667},{"id":"MTU4MDMzNg","url":"https://cdn2.thecatapi.com/images/MTU4MDMzNg.jpg","width":1161,"height":1280}]
            """
        case .addToFavorite:
            string = """
            {"id":100038507}
            """
        case .favorites:
            string = """
            [{
            "id":100038507,
            "image_id":"E8dL1Pqpz",
            "sub_id":null,
            "created_at":"2022-07-10T12:24:39.000Z",
            "image":{
                "id":"E8dL1Pqpz",
                "url":"https://cdn2.thecatapi.com/images/E8dL1Pqpz.jpg"
                }
            }]
            """
        case .removeFromFavorite:
            string = ""
        }

        return Data(string.utf8)
    }
}
