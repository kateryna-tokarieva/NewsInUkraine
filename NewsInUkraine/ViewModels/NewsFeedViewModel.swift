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
                self?.data = articlesData
                self?.articles = articlesData.articles
            })
            .store(in: &cancellables)
    }

    func saveArticle(article: Article) {
        let savedArticle = SavedArticle(context: viewContext)
        savedArticle.title = article.title
        savedArticle.descriptionText = article.description
        savedArticle.url = article.url
        savedArticle.urlToImage = article.urlToImage
        savedArticle.publishedAt = article.publishedAt
        
        do {
            try viewContext.save()
            print("Article saved successfully")
        } catch {
            print("Failed to save article: \(error.localizedDescription)")
        }
    }
}
