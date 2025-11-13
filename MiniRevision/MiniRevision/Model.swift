//
//  Model.swift
//  MiniRevision
//
//  Created by Aashi Mehrotra on 11/11/25.
//

import Foundation

// MARK: - Flashcard

struct Flashcard: Identifiable {
    // A requirement for SwiftUI lists and unique identification
    let id = UUID()
    
    // The front of the card
    var question: String
    
    // 🌟 NEW PROPERTY: Optional SF Symbol name for the question
    var questionImageName: String? // e.g., "star.fill" or "globe.americas.fill"
    
    // The back of the card
    var answer: String
    
    // Simple state tracking for study mode (Phase 2 feature, but good to include)
    // For now, we'll just use a simple Bool to track if the user 'knew' it.
    var isMastered: Bool = false
}

// MARK: - Topic

struct Topic: Identifiable {
    // A requirement for SwiftUI lists and unique identification
    let id = UUID()
    
    // The title the user sees on the Home Screen
    var title: String
    
    // The collection of flashcards in this topic
    var flashcards: [Flashcard]
}
