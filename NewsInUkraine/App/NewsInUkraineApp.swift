//
//  NewsInUkraineApp.swift
//  NewsInUkraine
//
//  Created by Катерина Токарева on 05.08.2024.
//

import SwiftUI

@main
struct NewsInUkraineApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NewsFeedView(context: persistenceController.container.viewContext)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
