//
//  NewsViewModelTests.swift
//  NewsAppDemo
//
//  Created by Rohit Sankpal on 10/02/25.
//
import Combine
import XCTest
@testable import NewsAppDemo

@MainActor
class NewsViewModelTests: XCTestCase {
    var viewModel: NewsViewModel!
    var mockNetworkService: MockNetworkService!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        
        mockNetworkService = MockNetworkService()

            viewModel = NewsViewModel(newsService: mockNetworkService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func test_fetchNews_Success() async throws {
        // Given
        let expectedNews = [
            NewsItems(source: Source(id: "1", name: "Test"),
                      author: "Test Author",
                      title: "Test Title",
                      description: "Test Description",
                      url: "https://test.com",
                      urlToImage: "https://test.com/image.jpg",
                      publishedAt: Date(),
                      content: "Test Content")
        ]
        
        let response = NewsResponseModel(status: "ok", totalResults: 1, articles: expectedNews)
        mockNetworkService.mockResult = .success(response)
        
        // When
        try await viewModel.fetchNews()
        
        // Then
        await MainActor.run {
            XCTAssertFalse(viewModel.news.isEmpty)
            XCTAssertEqual(viewModel.news.count, expectedNews.count)
            XCTAssertEqual(viewModel.news.first?.title, expectedNews.first?.title)
        }
    }
    
    func test_fetchNews_Failure() async {
        let expectedError = NetworkError.invalidResponse
        // Given
        mockNetworkService.mockResult = .failure(NetworkError.invalidResponse)
        
        // When /Then
        do {
            try await viewModel.fetchNews()
        } catch let error as NetworkError {
            XCTAssertEqual(error, expectedError, "the thrown error matches the expected error")
        } catch {
            XCTFail("Unexpected error type thrown: \(error)")
        }
        
        await MainActor.run {
            XCTAssertTrue(viewModel.news.isEmpty, "viewModel.news should be empty")
            XCTAssertNotNil(viewModel.error, "viewModel.error should not be nil")
        }
    }
}
