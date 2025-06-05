//
//  captionApp.swift
//  caption
//
//  Created by Miles Wilson on 5/27/25.
//

import SwiftUI
import SwiftData

@main
struct captionApp: App {

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ClipboardItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    

    var body: some Scene {
//        Settings {
//            EmptyView()
//        }
        MenuBarExtra("Caption", image: "MenuIcon") {
            ClipboardView(manager: ClipboardManager(context: sharedModelContainer.mainContext)).modelContainer(sharedModelContainer)
        }
        .menuBarExtraStyle(.window)
    }
}
