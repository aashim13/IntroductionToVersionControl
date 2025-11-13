//
//  ContentView.swift
//  MiniRevision
//
//  Created by Aashi Mehrotra on 10/11/25.
//

import SwiftUI

struct HomeView: View {
    
    // 1. Access the DataManager from the environment
    // This allows the view to read the @Published 'topics' array
    @EnvironmentObject var dataManager: DataManager
    
    // State for showing the sheet to add a new topic
    @State private var showingAddTopicSheet = false
    
    var body: some View {
        // 2. Wrap the view in a NavigationStack for iOS 16+ navigation
        NavigationStack {
            

            
            // 3. Display the list of topics
            List {
                // Iterate over the topics from the DataManager
                ForEach(dataManager.topics) { topic in
                    
                    // 4. NavigationLink pushes to the TopicDetailView
                    NavigationLink(destination: TopicDetailView(topic: topic)) {
                        VStack(alignment: .leading) {
                            Text(topic.title)
                                .font(.headline)
                            // Display the count of flashcards
                            Text("\(topic.flashcards.count) flashcards")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                // (Phase 2 feature: Add onDelete modifier for easy removal)
            }
            .navigationTitle("StudyStack") // Title for the navigation bar
            
            // 5. Add the New Topic Button in the Navigation Bar
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddTopicSheet = true // Trigger the sheet
                    } label: {
                        Label("Add Topic", systemImage: "plus.circle.fill")
                    }
                }
            }
            
            // 6. Present a simple sheet for adding a new topic
            // We'll use a simple alert-style sheet for Phase 1 prototype.
            .sheet(isPresented: $showingAddTopicSheet) {
                // Call a dedicated view/function to handle the creation
                addTopicSheet
            }
        }
    }
    
    // MARK: - New Topic Creation Sheet (Simple Prototype)
    
    private var addTopicSheet: some View {
        // Simple input for the new topic title
        AddTopicView(dataManager: dataManager, isPresented: $showingAddTopicSheet)
    }
}

#Preview {
    // 1. Create a DataManager instance
    let sampleDataManager = DataManager()
    
    // 2. Inject it into the HomeView for the Canvas to use
    HomeView()
        .environmentObject(sampleDataManager)
}
