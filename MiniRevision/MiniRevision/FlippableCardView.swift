//
//  FlippableCardView.swift
//  MiniRevision
//
//  Created by Aashi Mehrotra on 11/11/25.
//

import SwiftUI

struct FlippableCardView: View {
    // The flashcard data
    let card: Flashcard
    
    // Local state to track if the card is showing the answer (flipped)
    @State private var isFlipped: Bool = false
    
    // Local state for the animation effect
    @State private var rotation: Double = 0
    
    // The main view body
    var body: some View {
        ZStack {
            // Front (Question) View
            cardContent(text: card.question, imageName: card.questionImageName)
                // Hide the front when rotation reaches 90 degrees
                .opacity(isFlipped ? 0 : 1)
                // Apply the same rotation, but keep the z-axis rotation low
                .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
                
            // Back (Answer) View
            cardContent(text: card.answer, imageName: nil)
                // Only show the back when rotation reaches 90 degrees (or more)
                .opacity(isFlipped ? 1 : 0)
                // Flip the back content around its vertical axis to face the user correctly
                .rotation3DEffect(.degrees(rotation - 180), axis: (x: 0, y: 1, z: 0))
        }
        .onTapGesture {
            flipCard()
        }
    }
    
    // MARK: - Helper Views and Functions
    
    private func cardContent(text: String, imageName: String?) -> some View {
            VStack(spacing: 20) {
                
                // Display the image if the name is provided and not empty
                if let imageName = imageName, !imageName.isEmpty {
                    // Use Image(systemName:) for SF Symbols (our Phase 1 solution)
                    Image(systemName: imageName)
                        .font(.system(size: 80))
                        .foregroundColor(.accentColor)
                        .padding(.bottom, 10)
                }
                
                Text(text)
                    .font(.title)
                    .multilineTextAlignment(.center)
            }
            .padding(40)
            .frame(maxWidth: .infinity, maxHeight: 400) // Fixed size for the card area
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding()
        }
    
    private func flipCard() {
        // Toggle the flipped state
        isFlipped.toggle()
        
        // Use an animation block to make the state change smooth
        withAnimation(.easeOut(duration: 0.4)) {
            // If flipped, rotate 180 degrees. If unflipped, rotate back to 0 (or 360, etc.)
            rotation += 180
        }
    }
}

