//
//  NetworkService.swift
//  NewsAppDemo
//
//  Created by Rohit Sankpal on 10/02/25.
//

import Foundation
import Combine

enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case serverError(String)
}

class NetworkService: NetworkServiceProtocol {
    
    var baseURL: String {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let config = NSDictionary(contentsOfFile: path),
           let baseURL = config["BaseURL"] as? String {
            return baseURL
        }
        return ""
    }
    
    func fetchNewsData() -> AnyPublisher<NewsResponseModel, any Error> {
        guard let url = URL(string: baseURL) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidResponse
                }
                return data
            }
            .decode(type: NewsResponseModel.self, decoder: iSO8601Decoder())
            .mapError{ error in
                if let decoddingError = error as? DecodingError {
                    return decoddingError
                }
                return NetworkError.serverError(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    private func iSO8601Decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // Or .secondsSince1970, or your custom strategy
        // Add other decoder configurations if needed (e.g., keyDecodingStrategy)
        return decoder
    }
}
