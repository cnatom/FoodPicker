//
//  FavoriteItem.swift
//  NetworkManagerPractice
//
//  Created by atom on 2023/10/27.
//

import Foundation

struct FavoriteItem: Decodable {
    let id: Int
    let imageID: String
    let createdAt: Date
    let imageURL: URL

    enum CodingKeys: String, CodingKey {
        case id
        case imageID = "image_id"
        case createdAt = "created_at"
        case image
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        imageID = try container.decode(String.self, forKey: .imageID)
        createdAt = try container.decode(Date.self, forKey: .createdAt)

        let imageContainer = try container.nestedContainer(key: .image)
        imageURL = try imageContainer.decode(URL.self, forKey: "url")
    }
    
    init(catImage: CatImageViewModel,id: Int){
        self.id = id
        self.imageID = catImage.id
        self.createdAt = .now
        self.imageURL = catImage.url
    }
}
