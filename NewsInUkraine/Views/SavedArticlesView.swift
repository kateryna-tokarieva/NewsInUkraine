//
//  SavedArticlesView.swift
//  NewsInUkraine
//
//  Created by Катерина Токарева on 05.08.2024.
//

import SwiftUI
import CoreData

struct SavedArticlesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: SavedArticleViewModel
    
    init(viewModel: SavedArticleViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.articles.isEmpty {
                    emptyState
                } else {
                    articleList
                }
            }
        }
    }
    
    private var articleList: some View {
        List(viewModel.articles, id: \.url) { article in
            ArticleRowView(viewModel: ArticleRowViewModel(article: article, context: viewContext))
        }
    }
    
    private var emptyState: some View {
        VStack {
            Text("Додайте статті до збережених")
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
