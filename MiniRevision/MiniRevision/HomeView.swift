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
        
        // 🌟 1. Define the Gradient
        let lightBlueGradient = LinearGradient(
            // Start with a very light blue/teal, moving to a very light, almost white blue
            gradient: Gradient(colors: [
                Color(red: 0.85, green: 0.90, blue: 0.98), // Very light soft blue
                Color(red: 0.95, green: 0.98, blue: 1.0)  // Even lighter blue
            ]),
            startPoint: .top, // Start gradient at the top
            endPoint: .bottom // End gradient at the bottom
        )
        
        ZStack {
            
            // 3. Place the Gradient as the base layer
            Rectangle()
                .fill(lightBlueGradient)
                .edgesIgnoringSafeArea(.all) // Ensure the gradient covers the status bar area
            // 2. Wrap the view in a NavigationStack for iOS 16+ navigation
            NavigationStack {
                
                
                
                // 3. Display the list of topics
                List {
                    // Iterate over the topics from the DataManager
                    ForEach(dataManager.topics) { topic in
                        
                        // 4. NavigationLink pushes to the TopicDetailView
                        NavigationLink(destination: TopicDetailView(topic: topic)) {
                            HStack {
                                Image(systemName: "folder.fill").foregroundColor(Color.accentColor)
                                VStack(alignment: .leading) {
                                    Text(topic.title).font(.headline)
                                    Text("\(topic.flashcards.count) cards").font(.subheadline).foregroundColor(.secondary)
                                }
                                Spacer()
                                Text("\(topic.flashcards.count)")
                                    .padding(.horizontal, 10).padding(.vertical, 4)
                                    .background(Color.accentColor.opacity(0.15))
                                    .foregroundColor(Color.accentColor)
                                    .cornerRadius(10)
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                    // (Phase 2 feature: Add onDelete modifier for easy removal)
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
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
                    AddTopicView(dataManager: dataManager, isPresented: $showingAddTopicSheet)
                }
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
