//
//  ContentView.swift
//  NewsInUkraine
//
//  Created by Катерина Токарева on 05.08.2024.
//

import SwiftUI
import CoreData

struct NewsFeedView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: NewsFeedViewModel
    @State private var filter = ""
    @State private var showingSavedArticlesSheet = false
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: NewsFeedViewModel(context: context))
        
    }
    
    var body: some View {
        NavigationView {
            VStack {
                header
                Spacer()
                content
                Spacer()
            }
        }
    }
    
    var header: some View {
        HStack {
            TextField("Пошук", text: $filter, onCommit: {
                viewModel.filter = filter
                viewModel.fetchArticles()
            })
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                showingSavedArticlesSheet.toggle()
            }, label: {
                Image(systemName: "bookmark.fill")
            })
            .padding()
            .sheet(isPresented: $showingSavedArticlesSheet, onDismiss: {
                viewModel.fetchArticles()
            }) {
                SavedArticlesView(viewModel: SavedArticleViewModel(context: viewContext))
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
    
    var content: some View {
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
            ArticleRowView(viewModel: ArticleRowViewModel(article: article, context: viewContext))
        }
    }
    
    var emptyState: some View {
        VStack {
            ProgressView()
            Text("Завантаження новин...")
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

