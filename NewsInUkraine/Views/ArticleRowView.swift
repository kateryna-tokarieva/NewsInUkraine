//
//  ArticleRowView.swift
//  NewsInUkraine
//
//  Created by Екатерина Токарева on 05.08.2024.
//

import SwiftUI

struct ArticleRowView: View {
    let article: Article
    let onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
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

            NavigationLink(destination: ArticleDetailView(article: article)) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    if let sourceName = article.source.name {
                        Text(sourceName)
                            .padding(.top)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    if let description = article.description, !description.isEmpty {
                        Text(description)
                            .padding(.top)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                    }
                    Text(formatDate(article.publishedAt))
                        .padding(.top)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding()
            }

            HStack {
                Spacer()
                Button(action: {
                    onSave()
                }) {
                    Image(systemName: "bookmark")
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
}
