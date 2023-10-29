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
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            HStack {
                Text("猫咪图鉴")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button("换一批") {
                    Task {
                        await loadRandomImages()
                    }
                }
                .overlay {
                    if isLoading {
                        ProgressView()
                    }
                }
                .disabled(isLoading)
                .buttonStyle(.bordered)
                .font(.headline)
            }.padding(.horizontal)

            ScrollView {
                ForEach(catImages) { catImage in
                    let isFavourited = favorites.contains(where: \.imageID == catImage.id)
                    CatImageView(catImage, isFavourited: isFavourited) {
                        await toggleFavorite(catImage)
                    }
                }
            }
        }
        .alert(errorMessage: $errorMessage)
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
        do {
            isLoading = true
            defer {
                // NOTE: try之后的代码可能执行不到，因此这里采用defer确保isLoading一定能false
                isLoading = false
            }
            catImages = try await apiManager.getImages().map { CatImageViewModel($0) }
        } catch {
            errorMessage = "无法加载图片"
        }
    }

    func toggleFavorite(_ cat: CatImageViewModel) async {
        do {
            guard let index = favorites.firstIndex(where: \.imageID == cat.id) else {
                try await favorites.add(cat, apiManager: apiManager)
                return
            }
            try await favorites.remove(at: index, apiManager: apiManager)
        } catch {
            errorMessage = "无法更新最爱"
        }
    }
}

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

struct CatImageScreen_Previews: PreviewProvider, View {
    @State private var favorites: [FavoriteItem] = []

    var body: some View {
        CatImageScreen(favorites: $favorites)
    }

    static var previews: some View {
        Self()
//            .environment(\.apiManager, .stub)
    }
}
