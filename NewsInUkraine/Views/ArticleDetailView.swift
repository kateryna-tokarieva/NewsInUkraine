//
//  ArticleDetailView.swift
//  NewsInUkraine
//
//  Created by Екатерина Токарева on 05.08.2024.
//

import SwiftUI

struct ArticleDetailView: View {
    let article: Article

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(article.title)
                    .font(.largeTitle)
                    .padding(.top)
                if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else if phase.error != nil {
                            Text("Failed to load image")
                                .foregroundColor(.red)
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(height: 200)
                }
                if let description = article.description {
                    Text(description)
                        .font(.body)
                        .padding(.top)
                }
                if let author = article.author {
                    Text("Author: \(author)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle(article.title)
    }
}
