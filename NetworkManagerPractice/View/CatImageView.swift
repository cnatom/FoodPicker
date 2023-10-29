//
//  CatImageView.swift
//  NetworkManagerPractice
//
//  Created by Jane Chao on 2023/4/1.
//

import SwiftUI

struct CatImageView: View {
    @State private var phase: AsyncImagePhase
    private var session: URLSession = .imageSession

    private let catImage: CatImageViewModel
    private let isFavourited: Bool
    @State private var isLoading = false
    private var onDoubleTap: () async -> Void

    init(_ catImage: CatImageViewModel, isFavourited: Bool, session: URLSession = .imageSession, onDoubleTap: @escaping () async -> Void) {
        self.session = session
        self.catImage = catImage
        self.isFavourited = isFavourited
        self.onDoubleTap = onDoubleTap

        let urlRequest = URLRequest(url: catImage.url)
        if let data = session.configuration.urlCache?.cachedResponse(for: urlRequest)?.data,
           let uiImage = UIImage(data: data) {
            _phase = .init(wrappedValue: .success(.init(uiImage: uiImage)))
        } else {
            _phase = .init(wrappedValue: .empty)
        }
    }

    private var imageHeight: CGFloat? {
        guard let width = catImage.width, let height = catImage.height else {
            return nil
        }
        let scale = UIScreen.main.bounds.maxX / width
        return height * scale
    }

    var body: some View {
        Group {
            switch phase {
            case .empty:
                ProgressView()
                    .controlSize(.large)
                    .task { await load() }

            case let .success(image):
                image
                    .resizable()
                    .scaledToFit()
                    .overlay(alignment: .topTrailing) {
                        if !isLoading {
                            Image(systemName: "heart.fill")
                                .scaleEffect(isFavourited ? 1 : 0.0001)
                                .font(.largeTitle)
                                .padding()
                                .foregroundStyle(.pink)
                        }
                    }
                    .opacity(isLoading ? 0.5 : 1)
                    .animation(.default, value: isLoading)
                    .overlay(alignment: .topTrailing) {
                        if isLoading {
                            ProgressView()
                                .controlSize(.large)
                                .padding()
                        }
                    }
                    .onTapGesture(count: 2) {
                        Task {
                            isLoading = true
                            await onDoubleTap()
                            isLoading = false
                        }
                    }
                    .disabled(isLoading)

            case .failure:
                Color(.systemGray6)
                    .overlay {
                        Button("重新加载") {
                            phase = .empty
                        }
                    }

            @unknown default:
                fatalError("This has not been implemented.")
            }
        }
        .animation(.interactiveSpring(), value: isFavourited)
        .frame(maxWidth: .infinity, minHeight: 200)
        .frame(height: imageHeight)
    }
}

private extension CatImageView {
    func load() async {
        do {
            let urlRequest = URLRequest(url: catImage.url)
            let (data, response) = try await session.data(for: urlRequest)
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode,
                  let uiImage = UIImage(data: data)
            else {
                throw URLError(.unknown)
            }

            phase = .success(.init(uiImage: uiImage))
        } catch {
            phase = .failure(error)
        }
    }
}

struct CatImageView_Previews: PreviewProvider, View {
    @State private var isFavourited: Bool = false

    var body: some View {
        CatImageView([CatImageViewModel].stub.first!, isFavourited: isFavourited) {
            isFavourited.toggle()
        }
    }

    static var previews: some View {
        Self()
            .environment(\.apiManager, .stub)
    }
}
