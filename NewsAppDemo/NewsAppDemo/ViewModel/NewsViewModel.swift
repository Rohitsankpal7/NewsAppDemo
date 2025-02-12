//
//  NewsViewModel.swift
//  NewsAppDemo
//
//  Created by Rohit Sankpal on 10/02/25.
//
import Foundation
import Combine

@MainActor
class NewsViewModel: ObservableObject {
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: Error?
    @Published var news: [NewsItems] = []
    
    private let newsServiceProtocol: NetworkServiceProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(newsService: NetworkServiceProtocol = NetworkService()) {
        self.newsServiceProtocol = newsService
    }
    
    func fetchNews() async throws {
        isLoading = true
        do {
            let publisher = newsServiceProtocol.fetchNewsData()
            let response = try await publisher.async()
            print(response)
            news = response.articles
            self.error = nil
        } catch {
            self.error = error
            print(error)
        }
        isLoading = false
    }
}
// This Swift extension converts a Combine publisher into an async/await function, allowing you to use Combine-based APIs in Swift’s concurrency model.
extension Publisher {
    func async() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            
            cancellable = self.sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                },
                receiveValue: { value in
                    continuation.resume(returning: value)
                    cancellable?.cancel()
                }
            )
        }
    }
}
