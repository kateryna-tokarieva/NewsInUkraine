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
    @State private var isLoading = false
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: NewsFeedViewModel(context: context))
        
    }
    
    var body: some View {
        NavigationView {
            VStack {
                header
                content
            }
        }
        .onAppear {
            loadArticles()
        }
    }
    
    var header: some View {
        HStack {
            TextField("Пошук", text: $filter, onCommit: {
                debounceSearch()
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
                viewModel.fetchArticles() { _ in }
            }) {
                SavedArticlesView(viewModel: SavedArticleViewModel(context: viewContext))
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
    
    var content: some View {
        Group {
            if isLoading {
                Spacer()
                ProgressView("Завантаження новин...")
                    .padding()
                Spacer()
            } else if viewModel.articles.isEmpty {
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
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .foregroundColor(.secondary)
                .imageScale(.large)
            Text("Новини не знайдено")
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
    }
    
    private func loadArticles() {
        isLoading = true
        viewModel.fetchArticles { result in
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    private func debounceSearch() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            viewModel.filter = filter
            viewModel.fetchArticles() { _ in }
        }
    }
}

