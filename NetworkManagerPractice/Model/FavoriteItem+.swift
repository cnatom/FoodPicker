//
//  FavoriteItem+.swift
//  NetworkManagerPractice
//
//  Created by atom on 2023/10/29.
//

import Foundation


extension [FavoriteItem] {
    mutating func add(_ cat: CatImageViewModel, apiManager: CatAPIManager) async throws {
        let id = try await apiManager.addToFavorite(imageID: cat.id)
        append(.init(catImage: cat, id: id))
    }
    
    mutating func remove(at index: Int, apiManager: CatAPIManager) async throws {
        try await apiManager.removeFromfavorite(id: self[index].id)
        remove(at: index)
    }
}
