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
