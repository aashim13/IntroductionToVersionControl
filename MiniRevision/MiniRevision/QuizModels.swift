//
//  QuizModels.swift
//  MiniRevision
//
//  Created by Aashi Mehrotra on 11/11/25.
//

import Foundation

// Struct to represent one multiple-choice question
struct QuizQuestion {
    let questionText: String
    let answerText: String
    let options: [String] // The correct answer mixed with distractors
    let correctAnswer: String
}

// Extension on Topic to easily generate quizzes
extension Topic {
    
    /// Generates a list of QuizQuestion objects from the topic's flashcards.
    func generateQuiz() -> [QuizQuestion] {
        guard flashcards.count >= 4 else {
            // Need at least 4 cards to reliably generate 4-option questions
            return []
        }
        
        var quiz: [QuizQuestion] = []
        
        for card in flashcards {
            // 1. The Correct Answer
            let correctAnswer = card.answer
            
            // 2. The Distractors (Incorrect Options)
            // Filter out the current card's answer, then shuffle the rest and take the first 3
            let distractors = flashcards
                .map { $0.answer } // Get all answers
                .filter { $0 != correctAnswer } // Exclude the correct one
                .shuffled() // Mix them up
                .prefix(3) // Take the first three unique answers as distractors
            
            // 3. Assemble Options
            var options = [correctAnswer] + Array(distractors)
            options.shuffle() // Randomize the position of the correct answer
            
            // 4. Create the Question
            let question = QuizQuestion(
                questionText: card.question,
                answerText: card.answer, // Useful for the answer key/review later
                options: options,
                correctAnswer: correctAnswer
            )
            quiz.append(question)
        }
        
        return quiz.shuffled() // Shuffle the final list of questions
    }
}
