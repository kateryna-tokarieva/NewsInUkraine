//
//  ArticlesNetworkManager.swift
//  NewsInUkraine
//
//  Created by Екатерина Токарева on 05.08.2024.
//

import Foundation
import Combine

struct ArticlesDataService {
    static let shared = ArticlesDataService()
    
    private init() {}
    
    func fetchArticles(withFilter: String?) -> AnyPublisher<ArticlesData, Error> {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=ua&apiKey=\(API.key)") else {
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
