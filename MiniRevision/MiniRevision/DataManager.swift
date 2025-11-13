import Foundation
import SwiftUI
import Combine

// ObservableObject makes this class emit changes,
// allowing SwiftUI views to automatically update when a published property changes.
class DataManager: ObservableObject {
    
    // The @Published wrapper automatically notifies any listening SwiftUI view
    // whenever this array changes (e.g., when a new topic is added).
    @Published var topics: [Topic] = []
    
    init() {
        // Load sample data when the DataManager is initialized
        loadSampleData()
    }
    
    // MARK: - Data Operations (Phase 1 focus)
    
    func addTopic(title: String) {
        let newTopic = Topic(title: title, flashcards: [])
        topics.append(newTopic)
    }
    
    // Placeholder for more complex operations
    func updateFlashcardMastery(topicId: UUID, cardId: UUID, mastered: Bool) {
        // Find the topic and update the card's isMastered property
        if let topicIndex = topics.firstIndex(where: { $0.id == topicId }) {
            if let cardIndex = topics[topicIndex].flashcards.firstIndex(where: { $0.id == cardId }) {
                topics[topicIndex].flashcards[cardIndex].isMastered = mastered
            }
        }
    }
    
    // MARK: - Sample Data for Testing
    
    private func loadSampleData() {
        let swiftCards: [Flashcard] = [
            Flashcard(question: "What is the name of Harry Potter’s owl?", questionImageName: "square.stack.3d.up.fill", answer: "Hedwig"),
            Flashcard(question: "Who was the Half-Blood Prince?", questionImageName: "lasso.and.sparkles", answer: "Severus Snape"),
            Flashcard(question: "What position does Harry play on his Quidditch team?", questionImageName: nil, answer: "Seeker"),
            Flashcard(question: "What is the name of the three-headed dog guarding the Philosopher’s Stone?", questionImageName: nil, answer: "Seeker")
        ]
        
        let algebraCards: [Flashcard] = [
            Flashcard(question: "What is the name of Thor’s hammer?", answer: "Mjolnir"),
            Flashcard(question: "What metal is Captain America’s shield made of?", answer: "Vibranium"),
            Flashcard(question: "Which planet is Thanos from?", answer: "Titan")
        ]
        
        let swiftTopic = Topic(title: "Harry Potter Trivia", flashcards: swiftCards)
        let algebraTopic = Topic(title: "Marvel Trivia", flashcards: algebraCards)
        
        // Populate the published array
        topics = [swiftTopic, algebraTopic]
    }
}
