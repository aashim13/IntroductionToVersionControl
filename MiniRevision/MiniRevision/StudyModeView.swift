//
//  StudyModeView.swift
//  MiniRevision
//
//  Created by Aashi Mehrotra on 11/11/25.
//

import SwiftUI

struct StudyModeView: View {
    let topic: Topic
    
    // The index of the card currently being displayed
    @State private var currentCardIndex = 0
    
    // Simple logic to track cards the user got right (will be more complex later)
    @State private var cardsMastered = 0
    
    var body: some View {
        VStack {
            
            // Display the current card (if there are any)
            if topic.flashcards.isEmpty {
                Text("This topic is empty! Add some cards first.")
            } else if let currentCard = currentCard {
                
                // MARK: - Card Display
                
                // Use the FlippableCardView here
                FlippableCardView(card: currentCard)
                        // 🌟 THE FIX: Reset the view's identity when the index changes
                        .id(currentCardIndex)
                
                Spacer() // Pushes card to the top
                
                // MARK: - Action Buttons
                
                HStack(spacing: 30) {
                    // Button to mark the card for review (didn't know it)
                    ActionButton(title: "Needs Review", color: .red, systemImage: "xmark.circle.fill") {
                        moveToNextCard(mastered: false)
                    }
                    
                    // Button to mark the card as known (mastered)
                    ActionButton(title: "I Knew It", color: .green, systemImage: "checkmark.circle.fill") {
                        cardsMastered += 1 // Increment the score counter
                        moveToNextCard(mastered: true)
                    }
                }
                .padding(.horizontal)
                
            } else {
                // MARK: - Study Complete View
                
                StudyCompleteView(topicTitle: topic.title, cardsMastered: cardsMastered, totalCards: topic.flashcards.count)
            }
            
            Spacer() // Pushes everything up
            
        }
        .padding(.vertical)
        .navigationTitle("Studying: \(topic.title)")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Helper Logic
    
    var currentCard: Flashcard? {
        // Return the card if the index is valid, otherwise return nil (study is complete)
        topic.flashcards.indices.contains(currentCardIndex) ? topic.flashcards[currentCardIndex] : nil
    }
    
    func moveToNextCard(mastered: Bool) {
        // NOTE: In Phase 2, we would update the DataManager here.
        
        // Simple move to the next card
        currentCardIndex += 1
    }
}

// MARK: - Reusable Components

struct ActionButton: View {
    let title: String
    let color: Color
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: systemImage)
                    .font(.largeTitle)
                Text(title)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(10)
        }
    }
}

struct StudyCompleteView: View {
    let topicTitle: String
    let cardsMastered: Int
    let totalCards: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "flag.checkered")
                .font(.largeTitle)
                .foregroundColor(.accentColor)
            
            Text("Session Complete!")
                .font(.largeTitle)
            
            Text("You reviewed all \(totalCards) cards in '\(topicTitle)'.")
                .foregroundColor(.secondary)
            
            Text("Mastered: \(cardsMastered) / \(totalCards)")
                .font(.headline)
            
            // NOTE: In a real app, you'd add a "Go Back" button.
        }
        .padding(40)
    }
}
