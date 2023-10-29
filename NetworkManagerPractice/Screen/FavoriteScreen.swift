//
//  FavoriteScreen.swift
//  NetworkManagerPractice
//
//  Created by Jane Chao on 2023/4/1.
//

import SwiftUI

struct FavoriteScreen: View {
    @Environment(\.apiManager) private var apiManager
    @Binding var favorites: [FavoriteItem]
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            Text("我的最愛")
                .font(.largeTitle.bold())

            ScrollView {
                if favorites.isEmpty {
                    Text("双击图片添加到最爱 😊")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .offset(x: favorites.isEmpty ? 0 : -UIScreen.main.bounds.maxX)
                        .font(.title3)
                        .padding()
                }

                ForEach(Array(favorites.enumerated()), id: \.element.imageID) { index, favoriteItem in
                    CatImageView(.init(favoriteItem: favoriteItem), isFavourited: true) {
                        do {
                            try await favorites.remove(at: index, apiManager: apiManager)
                        } catch {
                            errorMessage = "无法移除最爱项目"
                        }
                    }.transition(.slide)
                }
            }
        }
        .animation(.spring(), value: favorites)
        .alert(errorMessage: $errorMessage)
    }
}

extension FavoriteItem: Equatable {
    static func == (lhs: FavoriteItem, rhs: FavoriteItem) -> Bool {
        return lhs.imageID == rhs.imageID
    }
}

struct FavoriteScreen_Previews: PreviewProvider, View {
    @State private var favorites: [FavoriteItem] = [CatImageViewModel].stub.enumerated().map { item in
        FavoriteItem(catImage: item.element, id: item.offset)
    }

    var body: some View {
        FavoriteScreen(favorites: $favorites)
            .environment(\.apiManager, .stub)
    }

    static var previews: some View {
        Self()
    }
}
