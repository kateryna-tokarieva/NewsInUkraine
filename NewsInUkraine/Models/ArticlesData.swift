//
//  ArticlesData.swift
//  NewsInUkraine
//
//  Created by Катерина Токарева on 05.08.2024.
//

import Foundation

// MARK: - ArticlesData
struct ArticlesData: Codable, Hashable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable, Hashable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    var isSaved: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
    }
}

// MARK: - Source
struct Source: Codable, Hashable {
    let name: String?
}
