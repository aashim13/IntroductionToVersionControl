//
//  AddTopicView.swift
//  MiniRevision
//
//  Created by Aashi Mehrotra on 11/11/25.
//

import SwiftUI

struct AddTopicView: View {
    @ObservedObject var dataManager: DataManager // Access the manager
    @Binding var isPresented: Bool              // Binding to dismiss the sheet
    
    @State private var newTopicTitle: String = "" // Local state for the text field
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Topic Title (e.g., Physics 101)", text: $newTopicTitle)
            }
            .navigationTitle("New Topic")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false // Dismiss without saving
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // Check for empty title before saving
                        if !newTopicTitle.isEmpty {
                            dataManager.addTopic(title: newTopicTitle) // Add to manager
                            isPresented = false // Dismiss after saving
                        }
                    }
                    // Disable the Save button if the title is empty
                    .disabled(newTopicTitle.isEmpty)
                }
            }
        }
    }
}
