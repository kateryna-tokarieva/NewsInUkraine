//
//  ContentView.swift
//  NewsInUkraine
//
//  Created by Екатерина Токарева on 05.08.2024.
//

import SwiftUI

struct NewsFeed: View {
    @ObservedObject var viewModel = HomeViewModel()
    @State private var filter = ""
    
    var body: some View {
        NavigationView {
            VStack {
                header
                Spacer()
                content
                Spacer()
            }
            .onAppear {
                viewModel.fetchArticles()
            }
        }
    }
    
    var header: some View {
        TextField("Пошук", text: $filter, onCommit: {
            viewModel.filter = filter
            viewModel.fetchArticles()
        })
        .padding()
        .textFieldStyle(RoundedBorderTextFieldStyle())
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
            NavigationLink(destination: ArticleDetailView(article: article)) {
                VStack(alignment: .leading, spacing: 8) {
                    if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } else if phase.error != nil {
                                Text("Не вдалося завантажити зображення")
                                    .foregroundColor(.red)
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(height: 200)
                    }
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text(article.title)
                                .padding()
                                .font(.headline)
                            if let sourceName = article.source.name {
                                Text(sourceName)
                                    .padding(.leading)
                                    .padding(.trailing)
                                    .padding(.bottom)
                                    .font(.subheadline)
                            }
                            if let description = article.description, !description.isEmpty {
                                Text(description)
                                    .padding(.leading)
                                    .padding(.trailing)
                                    .padding(.bottom)
                                    .font(.body)
                                    .lineLimit(2)
                            }
                            HStack {
                                Spacer()
                                Text(formatDate(article.publishedAt))
                                    .font(.footnote)
                            }
                            .padding(.leading)
                            .padding(.trailing)
                            .padding(.bottom)
                        }
                        
                    }
                    .padding(.vertical, 8)
                }
            }
        }
    }
    
    var emptyState: some View {
        VStack {
            ProgressView()
            Text("Завантаження новин...")
                .foregroundColor(.gray)
        }
        .padding()
    }
    
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return dateString
    }
}

#Preview {
    NewsFeed()
}
