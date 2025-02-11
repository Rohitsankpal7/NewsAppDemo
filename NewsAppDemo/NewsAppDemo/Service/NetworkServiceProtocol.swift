//
//  NetworkServiceProtocol.swift
//  NewsAppDemo
//
//  Created by Rohit Sankpal on 10/02/25.
//

import Combine

protocol NetworkServiceProtocol {
    func fetchNewsData() -> AnyPublisher<NewsResponseModel, Error>
}


//5711ea75277e438a98a5a65330f16f4c
