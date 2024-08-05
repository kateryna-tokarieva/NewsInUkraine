//
//  HomeViewModel.swift
//  NewsInUkraine
//
//  Created by Екатерина Токарева on 05.08.2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    var filter: String?
    @Published var data: ArticlesData?
    @Published var articles: [Article] = []
    
    private var service = ArticlesDataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchArticles()
    }
    
    func fetchArticles() {
        service.fetchArticles(withFilter: filter)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error fetching articles: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] articlesData in
                self?.data = articlesData
                self?.articles = articlesData.articles
            })
            .store(in: &cancellables)
    }

}
