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
        var isSaved = false
        let fetchRequest: NSFetchRequest<SavedArticle> = SavedArticle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", article.url)

        DispatchQueue.global().async {
            do {
                let results = try self.context.fetch(fetchRequest)
                isSaved = !results.isEmpty
                DispatchQueue.main.async {
                    self.article.isSaved = isSaved
                }
            } catch {
                print("Failed to check saved status: \(error.localizedDescription)")
            }
        }

        return isSaved
    }

    func saveArticle() {
        guard !article.isSaved else { return }

        DispatchQueue.global().async {
            let savedArticle = SavedArticle(context: self.context)
            savedArticle.title = self.article.title
            savedArticle.descriptionText = self.article.description
            savedArticle.url = self.article.url
            savedArticle.urlToImage = self.article.urlToImage
            savedArticle.publishedAt = self.article.publishedAt
            savedArticle.isSaved = true

            do {
                try self.context.save()
                DispatchQueue.main.async {
                    self.article.isSaved = true
                    NotificationCenter.default.post(name: .articleSaved, object: nil)
                    print("Article \(self.article.title) saved successfully")
                }
            } catch {
                print("Failed to save article: \(error.localizedDescription)")
            }
        }
    }

    func deleteArticle() {
        let fetchRequest: NSFetchRequest<SavedArticle> = SavedArticle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", article.url)

        DispatchQueue.global().async {
            do {
                let results = try self.context.fetch(fetchRequest)
                for result in results {
                    self.context.delete(result)
                }
                try self.context.save()
                DispatchQueue.main.async {
                    self.article.isSaved = false
                    NotificationCenter.default.post(name: .articleDeleted, object: nil)
                    print("Article \(self.article.title) deleted successfully")
                }
            } catch {
                print("Failed to delete article: \(error.localizedDescription)")
            }
        }
    }
}

extension Notification.Name {
    static let articleDeleted = Notification.Name("articleDeleted")
    static let articleSaved = Notification.Name("articleSaved")
}
