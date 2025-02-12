//
//  NetworkServiceTests.swift
//  NewsAppDemo
//
//  Created by Rohit Sankpal on 10/02/25.
//

import XCTest
import Combine
@testable import NewsAppDemo

final class NetworkServiceTests: XCTestCase {
    var networkService: NetworkService!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        
        // Configure Mock URLSession
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        networkService = NetworkService(session: session)
    }

    override func tearDown() {
        networkService = nil
        cancellables.removeAll()
        super.tearDown()
    }

    // Test: Successful API Response
    func test_fetchNewsData_Success() {
        // Given
        let jsonResponse = """
        {
            "status": "ok",
            "totalResults": 1,
            "articles": [
                {
                    "source": { "id": "1", "name": "Test Source" },
                    "author": "Test Author",
                    "title": "Test Title",
                    "description": "Test Description",
                    "url": "https://test.com",
                    "urlToImage": "https://test.com/image.jpg",
                    "publishedAt": "2024-02-10T12:00:00Z",
                    "content": "Test Content"
                }
            ]
        }
        """.data(using: .utf8)!

        let urlResponse = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: nil)!

        MockURLProtocol.responseData = jsonResponse
        MockURLProtocol.response = urlResponse
        MockURLProtocol.error = nil

        // When
        let expectation = XCTestExpectation(description: "Fetch news successfully")
        
        networkService.fetchNewsData()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Unexpected error: \(error)")
                }
            }, receiveValue: { response in
                // Then
                XCTAssertEqual(response.status, "ok")
                XCTAssertEqual(response.totalResults, 1)
                XCTAssertEqual(response.articles.first?.title, "Test Title")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
    }

    func test_fetchNewsData_InvalidResponse() {
        // Given
        let urlResponse = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                          statusCode: 500,
                                          httpVersion: nil,
                                          headerFields: nil)!

        MockURLProtocol.responseData = nil
        MockURLProtocol.response = urlResponse
        MockURLProtocol.error = nil

        // When
        let expectation = XCTestExpectation(description: "Handle invalid response")
        
        networkService.fetchNewsData()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertTrue(error is NetworkError)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure, but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but got success")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
    }

    // Test: Decoding Failure
    func test_fetchNewsData_DecodingFailure() {
        // Given
        let invalidJsonResponse = """
        {
            "status": "ok",
            "totalResults": 1,
            "articles": [
                {
                    "source": { "id": "1", "name": "Test Source" },
                    "author": "Test Author",
                    "title": "Test Title",
                    "description": "Test Description",
                    "url": "https://test.com",
                    "urlToImage": "https://test.com/image.jpg",
                    "publishedAt": "InvalidDateFormat",
                    "content": "Test Content"
                }
            ]
        }
        """.data(using: .utf8)!

        let urlResponse = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: nil)!

        MockURLProtocol.responseData = invalidJsonResponse
        MockURLProtocol.response = urlResponse
        MockURLProtocol.error = nil

        // When
        let expectation = XCTestExpectation(description: "Handle decoding failure")
        
        networkService.fetchNewsData()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertTrue(error is DecodingError)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected decoding error, but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected decoding error, but got success")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
    }
}
