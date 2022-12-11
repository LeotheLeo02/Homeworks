//
//  HomeworksApp.swift
//  Homeworks
//
//  Created by Nate on 11/21/22.
//

import SwiftUI

@main
struct HomeworksApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
