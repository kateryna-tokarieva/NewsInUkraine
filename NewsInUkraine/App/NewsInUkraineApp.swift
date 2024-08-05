//
//  NewsInUkraineApp.swift
//  NewsInUkraine
//
//  Created by Екатерина Токарева on 05.08.2024.
//

import SwiftUI

@main
struct NewsInUkraineApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NewsFeed()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
