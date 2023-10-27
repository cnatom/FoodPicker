//
//  CatImagesScreen.swift
//  NetworkManagerPractice
//
//  Created by Jane Chao on 2023/4/1.
//

import SwiftUI

struct CatImageScreen: View {
    
    @Environment(\.apiManager) var apiManager: CatAPIManager
    
    @Binding var favorites: [FavoriteItem]
    
    @State private var catImages: [CatImageViewModel] = []
    @State private var didFirstLoad: Bool = false
    

    var body: some View {
        VStack {
            HStack {
                Text("猫咪图鉴")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                /// FIXME: 不该等网络请求结束之后才有动画
                Button("换一批") { Task { await loadRandomImages() } }
                    .buttonStyle(.bordered)
                    .font(.headline)
            }.padding(.horizontal)
            
            ScrollView {
                ForEach(catImages) { catImage in
                    let isFavourited = favorites.contains(where: \.imageID == catImage.id)
                    CatImageView(catImage, isFavourited: isFavourited) {
                        Task{
                            /// FIXME: error handling & pass async closure
                            try! await toggleFavorite(catImage)
                        }
                    }
                }
            }
        }
        .task {
            if !didFirstLoad {
                await loadRandomImages()
                didFirstLoad = true
            }
        }
    }
}

private extension CatImageScreen {
    func loadRandomImages() async {
        /// FIXME: error handling
        do{
            catImages = try await apiManager.getImages().map{CatImageViewModel($0)}
        }catch{
            print("\(error)")
        }
    }
    
    func toggleFavorite(_ cat: CatImageViewModel)async throws{
        guard let index = favorites.firstIndex(where: \.imageID == cat.id)  else {
            try await favorites.add(cat, apiManager: apiManager)
            return
        }
        try await favorites.remove(at: index,apiManager: apiManager)
    }
}


extension [FavoriteItem] {
    mutating func add(_ cat: CatImageViewModel,apiManager: CatAPIManager)async throws {
        let id = try await apiManager.addToFavorite(imageID: cat.id)
        self.append(.init(catImage: cat, id: id))
    }
    
    mutating func remove(at index: Int,apiManager: CatAPIManager)async throws {
        try await apiManager.removeFromfavorite(id: self[index].id)
        self.remove(at: index)
    }
}


struct CatImageScreen_Previews: PreviewProvider, View {
    @State private var favorites: [FavoriteItem] = []
    
    var body: some View {
        CatImageScreen(favorites: $favorites)
    }
    
    static var previews: some View {
        Self()
            .environment(\.apiManager, .stub)
    }
}
