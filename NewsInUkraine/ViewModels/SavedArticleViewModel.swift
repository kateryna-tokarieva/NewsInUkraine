//
//  SavedArticleViewModel.swift
//  NewsInUkraine
//
//  Created by Катерина Токарева on 05.08.2024.
//

import Foundation
import CoreData

class SavedArticleViewModel: ObservableObject {
    @Published var articles: [Article] = []
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchSavedArticles()
        
        NotificationCenter.default.addObserver(self, selector: #selector(articleDeleted(_:)), name: .articleDeleted, object: nil)
    }
    
    func fetchSavedArticles() {
        let fetchRequest: NSFetchRequest<SavedArticle> = SavedArticle.fetchRequest()
        
        do {
            let savedArticles = try context.fetch(fetchRequest)
            articles = savedArticles.map { savedArticle in
                Article(
                    source: Source(name: savedArticle.sourceName ?? ""),
                    author: nil,
                    title: savedArticle.title ?? "",
                    description: savedArticle.descriptionText,
                    url: savedArticle.url ?? "",
                    urlToImage: savedArticle.urlToImage,
                    publishedAt: savedArticle.publishedAt ?? ""
                )
            }
            print("Saved Articles: \(articles)")
        } catch {
            print("Failed to fetch saved articles: \(error.localizedDescription)")
        }
    }
    
    @objc func articleDeleted(_ notification: Notification) {
        print("Article deleted notification received")
        fetchSavedArticles()
    }
}
