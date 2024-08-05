//
//  SavedArticleViewModel.swift
//  NewsInUkraine
//
//  Created by Екатерина Токарева on 05.08.2024.
//

import Foundation

class SavedArticleViewModel: ObservableObject {
    @Published var articles: [Article] = []
}
