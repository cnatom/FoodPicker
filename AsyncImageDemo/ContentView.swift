//
//  ContentView.swift
//  AsyncImageDemo
//
//  Created by atom on 2023/10/13.
//

import SwiftUI

extension URLSession {
    static let imageSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.urlCache = .imageCache
        let session = URLSession(configuration: config)
        return session
    }()
}

extension URLCache {
    static let imageCache: URLCache = {
        .init(memoryCapacity: 20 * 1024 * 1024,
              diskCapacity: 30 * 1024 * 1024)
    }()
}

// NOTE: 有cache机制的AsyncImageView
struct MyAsyncImage: View {
    @State private var phase: AsyncImagePhase

    private var session: URLSession = .imageSession

    let urlRequest: URLRequest

    init(url: URL) {
        self.urlRequest = .init(url: url)
        if let cached = session.configuration.urlCache?.cachedResponse(for: urlRequest),
           let uiImage = UIImage(data: cached.data) {
            // NOTE: 延后初始化 @State 的wrappedValue值
            // 这样的话就不用写 @State private var phase: AsyncImagePhase = .empty了
            // phase = .success(Image(uiImage: uiImage))
            _phase = .init(wrappedValue: .success(Image(uiImage: uiImage)))
        }else{
            _phase = .init(wrappedValue: .empty)
        }
    }

    var body: some View {
        Group{
            switch phase {
            case .empty:
                ProgressView()
                    .task {
                        //                    try? await Task.sleep(for: Duration.seconds(1))
                        await load()
                    }
            case let .success(image):
                image.resizable()
            case .failure:
                Text("加载失败")
            @unknown default:
                fatalError("图片加载失败")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    func load() async {
        do {
            let (data, response) = try await session.data(for: urlRequest)
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode,
                  let uiImage = UIImage(data: data) else {
                throw URLError(.unknown)
            }
            phase = .success(Image(uiImage: uiImage))
        } catch {
            phase = .failure(error)
        }
    }
}

struct ContentView: View {
    let url = URL(string: "https://cdn.pixabay.com/photo/2023/08/11/06/12/boy-8182923_640.jpg")

    @State private var id = UUID()

    var body: some View {
        NavigationView {
            VStack {
                MyAsyncImage(url: url!)
                    .id(id)
                Button("重新加载") {
                    self.id = UUID()
                }
            }
            .navigationTitle("AsyncImageDemo")
        }
    }
}

#Preview {
    ContentView()
}
