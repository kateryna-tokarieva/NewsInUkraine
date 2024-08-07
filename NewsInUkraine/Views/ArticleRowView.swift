//
//  ArticleRowView.swift
//  NewsInUkraine
//
//  Created by Катерина Токарева on 05.08.2024.
//

import SwiftUI

struct ArticleRowView: View {
    @ObservedObject var viewModel: ArticleRowViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let imageUrl = viewModel.article.urlToImage, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .frame(width: UIScreen.main.bounds.width - 100)
                            .clipped()
                    } else if phase.error != nil {
                        Text("Не вдалося завантажити зображення")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        ProgressView()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            
            NavigationLink(destination: ArticleDetailView(article: viewModel.article)) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.article.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    if let sourceName = viewModel.article.source.name {
                        Text(sourceName)
                            .padding(.top)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    if let description = viewModel.article.description, !description.isEmpty {
                        Text(description)
                            .padding(.top)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                    }
                    Text(formatDate(viewModel.article.publishedAt))
                        .padding(.top)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            
            HStack {
                Spacer()
                Button(action: {
                    toggleSaveStatus()
                }) {
                    Image(systemName: viewModel.article.isSaved ? "bookmark.fill" : "bookmark")
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
    
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "uk_UA")
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return dateString
    }
    
    private func toggleSaveStatus() {
        if viewModel.article.isSaved {
            viewModel.deleteArticle()
        } else {
            viewModel.saveArticle()
        }
    }
}
