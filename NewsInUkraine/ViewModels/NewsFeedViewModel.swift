//
//  HomeViewModel.swift
//  NewsInUkraine
//
//  Created by Катерина Токарева on 05.08.2024.
//

import Foundation
import Combine
import CoreData

class NewsFeedViewModel: ObservableObject {
    @Published var data: ArticlesData?
    @Published var articles: [Article] = []

    var filter: String?
    private var service = ArticlesDataService.shared
    private var cancellables = Set<AnyCancellable>()
    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
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
                print("Fetched Articles")
                self?.articles = articlesData.articles
            })
            .store(in: &cancellables)
    }
}
