//
//  SavedArticlesView.swift
//  NewsInUkraine
//
//  Created by Екатерина Токарева on 05.08.2024.
//

import SwiftUI

struct SavedArticlesView: View {
    @StateObject var viewModel: SavedArticleViewModel
    
    var body: some View {
        Group {
            if viewModel.articles.isEmpty {
                emptyState
            } else {
                articles
            }
        }
    }
    
    var articles: some View {
        List(viewModel.articles, id: \.self) { article in
            NavigationLink(destination: ArticleDetailView(article: article)) {
                ArticleRowView(article: article) {
                }
            }
        }
    }
    
    var emptyState: some View {
        VStack {
            Text("Додайте статті до збережених")
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

