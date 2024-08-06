//
//  ArticleRowViewModel.swift
//  NewsInUkraine
//
//  Created by Катерина Токарева on 05.08.2024.
//

import Foundation
import CoreData

class ArticleRowViewModel: ObservableObject {
    @Published var article: Article
    private let context: NSManagedObjectContext

    init(article: Article, context: NSManagedObjectContext) {
        self.article = article
        self.context = context
        self.article.isSaved = isArticleSaved()
    }

    private func isArticleSaved() -> Bool {
            let fetchRequest: NSFetchRequest<SavedArticle> = SavedArticle.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "url == %@", article.url)

            do {
                let results = try context.fetch(fetchRequest)
                let isSaved = !results.isEmpty
                print("Checking if article \(article.title) is saved: \(isSaved)")
                return isSaved
            } catch {
                print("Failed to check saved status: \(error.localizedDescription)")
                return false
            }
        }
    
    func saveArticle() {
        let savedArticle = SavedArticle(context: context)
        savedArticle.title = article.title
        savedArticle.descriptionText = article.description
        savedArticle.url = article.url
        savedArticle.urlToImage = article.urlToImage
        savedArticle.publishedAt = article.publishedAt
        savedArticle.isSaved = true

        do {
            try context.save()
            article.isSaved = true
                        print("Article \(article.title) saved successfully")
                    } catch {
                        print("Failed to save article: \(error.localizedDescription)")
                    }
    }

    func deleteArticle() {
            let fetchRequest: NSFetchRequest<SavedArticle> = SavedArticle.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "url == %@", article.url)

            do {
                let results = try context.fetch(fetchRequest)
                for result in results {
                    context.delete(result)
                }
                try context.save()
                article.isSaved = false
                print("Article \(article.title) deleted successfully")
                NotificationCenter.default.post(name: .articleDeleted, object: nil)
            } catch {
                print("Failed to delete article: \(error.localizedDescription)")
            }
        }

}

extension Notification.Name {
    static let articleDeleted = Notification.Name("articleDeleted")
    static let articleSaved = Notification.Name("articleSaved")
}
