//
//  HomeScreen.swift
//  NetworkManagerPractice
//
//  Created by Jane Chao on 2023/4/1.
//

import SwiftUI

// FIXME: Better implementation for handling favorites.
struct HomeScreen: View {
    @Environment(\.apiManager) private var apiManager
    @State private var tab: Tab = .images
    @State private var errorMessage: String?
    @State private var favoriteImages: [FavoriteItem] = []

    var body: some View {
        TabView(selection: $tab) {
            CatImageScreen(favorites: $favoriteImages)
                .tabItem { Label("Home", systemImage: "house") }
                .tag(Tab.images)

            FavoriteScreen(favorites: $favoriteImages)
                .tabItem { Label("Favorite", systemImage: "heart.fill") }
                .tag(Tab.favorites)
        }
        .alert(errorMessage: $errorMessage)
        .task {
            await loadFavorites()
        }
    }
}

private extension HomeScreen {
    func loadFavorites() async {
        do {
            favoriteImages = try await apiManager.getFavorite()
        } catch {
            errorMessage = "载入最新资料失败"
        }
    }
}

private extension HomeScreen {
    enum Tab {
        case images, favorites
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
            .environment(\.apiManager, .stub)
    }
}
