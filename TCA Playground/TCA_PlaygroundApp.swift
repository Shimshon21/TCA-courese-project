//
//  TCA_PlaygroundApp.swift
//  TCA Playground
//
//  Created by Shimshon on 06/02/2024.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct TCA_PlaygroundApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    static let store = Store(initialState: ContactsFeature.State()) {
        ContactsFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            ContactsView(store: TCA_PlaygroundApp.store)
        }
    }
}
