//
//  MiniRevisionApp.swift
//  MiniRevision
//
//  Created by Aashi Mehrotra on 10/11/25.
//

import SwiftUI

@main
struct StudyStackApp: App {
    
    // 1. Create the DataManager instance once and keep it alive
    // @StateObject ensures the object persists for the life of the app.
    @StateObject var dataManager = DataManager()
    
    var body: some Scene {
        WindowGroup {
            // 2. Inject the manager into the environment
            HomeView()
                .environmentObject(dataManager) // Makes it available to HomeView and all subviews
                //.tint(.green)
        }
    }
}
