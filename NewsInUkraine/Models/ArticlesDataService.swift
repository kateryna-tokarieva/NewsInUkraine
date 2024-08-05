//
//  ArticlesNetworkManager.swift
//  NewsInUkraine
//
//  Created by Катерина Токарева on 05.08.2024.
//

import Foundation
import Combine

struct ArticlesDataService {
    static let shared = ArticlesDataService()
    
    private init() {}
    
    func fetchArticles(withFilter filter: String?) -> AnyPublisher<ArticlesData, Error> {
        let baseURL = filter == nil || filter!.isEmpty ? "https://newsapi.org/v2/top-headlines" : "https://newsapi.org/v2/everything"
        
        var components = URLComponents(string: baseURL)!
        
        components.queryItems = [
            URLQueryItem(name: "apiKey", value: API.key)
        ]
        
        if filter == nil || filter!.isEmpty {
            components.queryItems?.append(URLQueryItem(name: "country", value: "ua"))
        } else {
            components.queryItems?.append(URLQueryItem(name: "q", value: filter))
        }
        
        guard let url = components.url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        print("Fetching articles from URL: \(url)")
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .handleEvents(receiveOutput: { data in
                print("Received data: \(String(data: data, encoding: .utf8) ?? "No data")")
            })
            .decode(type: ArticlesData.self, decoder: JSONDecoder())
            .handleEvents(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error fetching articles: \(error.localizedDescription)")
                }
            })
            .eraseToAnyPublisher()
    }
}
