//
//  MockNetworkService.swift
//  NewsAppDemo
//
//  Created by Rohit Sankpal on 11/02/25.
//
import Combine
import Foundation
@testable import NewsAppDemo

class MockNetworkService: NetworkServiceProtocol {
    var mockResult: Result<NewsResponseModel, Error>?
    func fetchNewsData() -> AnyPublisher<NewsAppDemo.NewsResponseModel, any Error> {
        guard let result = mockResult else {
            return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
        }
        
        return result.publisher.eraseToAnyPublisher()
    }
}
