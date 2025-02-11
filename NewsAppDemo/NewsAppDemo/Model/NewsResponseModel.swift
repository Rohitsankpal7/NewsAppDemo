//
//  NewsResponseModel.swift
//  NewsAppDemo
//
//  Created by Rohit Sankpal on 10/02/25.
//
import Foundation

struct NewsResponseModel: Decodable {
    let status: String
    let totalResults: Int
    let articles: [NewsItems]
}

struct NewsItems: Identifiable, Decodable {
    let id = UUID() // For SwiftUI lists
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date?
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case source, author, title, description, url, urlToImage, publishedAt, content
    }
}

struct Source: Decodable {
    let id: String?
    let name: String?
}


extension Date {
    func longDateFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy" // The magic string
        return formatter.string(from: self)
    }
}
