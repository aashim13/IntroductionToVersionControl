//
//  QuizModeView.swift
//  MiniRevision
//
//  Created by Aashi Mehrotra on 11/11/25.
//

import SwiftUI

struct QuizModeView: View {
    // The Topic passed from the detail screen
    let topic: Topic
    
    // State to hold the generated quiz questions
    @State private var quizQuestions: [QuizQuestion] = []
    
    // State to track the current question index
    @State private var currentQuestionIndex = 0
    
    // State to track the score
    @State private var score = 0
    
    // State to track if the quiz is over
    @State private var isQuizFinished = false
    
    var body: some View {
        VStack {
            
            // MARK: - Quiz Flow (Handles the 3 main states)
            
            if quizQuestions.isEmpty {
                // State 1: Not enough cards for a quiz (less than 4)
                VStack(spacing: 20) {
                    Text("Quiz Unavailable")
                        .font(.title)
                    Text("This topic needs at least 4 flashcards to generate a multiple-choice quiz. You currently have \(topic.flashcards.count).")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(40)
            } else if isQuizFinished {
                // State 2: Quiz is finished
                QuizSummaryView(score: score, totalQuestions: quizQuestions.count)
            } else {
                // State 3: Quiz is running (Display the current question)
                
                // Display the progress
                Text("Question \(currentQuestionIndex + 1) of \(quizQuestions.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top)
                
                let currentQuestion = quizQuestions[currentQuestionIndex]
                
                // Display the Question Text
                Text(currentQuestion.questionText)
                    .font(.title2)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 30)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.orange.opacity(0.1)))
                    .padding()
                
                // Display the Multiple Choice Options
                VStack(spacing: 12) {
                    ForEach(currentQuestion.options, id: \.self) { option in
                        QuizOptionButton(option: option) {
                            handleAnswer(selectedAnswer: option, correctAnswer: currentQuestion.correctAnswer)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .navigationTitle("Quiz: \(topic.title)")
        .navigationBarTitleDisplayMode(.inline)
        // Initial setup when the view first appears
        .onAppear {
            if !topic.flashcards.isEmpty {
                quizQuestions = topic.generateQuiz()
                // If the generation failed (e.g., less than 4 cards), the array will be empty,
                // and the view will show the "Quiz Unavailable" message.
            }
        }
    }
    
    // MARK: - Quiz Logic
    
    func handleAnswer(selectedAnswer: String, correctAnswer: String) {
        // 1. Check if the answer is correct
        if selectedAnswer == correctAnswer {
            score += 1
        }
        
        // 2. Move to the next question or finish the quiz
        if currentQuestionIndex < quizQuestions.count - 1 {
            currentQuestionIndex += 1
        } else {
            isQuizFinished = true // End of the quiz
        }
    }
}

// MARK: - Reusable Quiz Components

// Simple button style for an option
struct QuizOptionButton: View {
    let option: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(option)
                .font(.body)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .foregroundColor(.primary)
                .cornerRadius(10)
                .multilineTextAlignment(.leading)
        }
    }
}

// Summary Screen (State 2)
struct QuizSummaryView: View {
    @Environment(\.dismiss) var dismiss // To dismiss/pop the view
    let score: Int
    let totalQuestions: Int
    
    var body: some View {
        VStack(spacing: 25) {
            Image(systemName: "trophy.fill")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            Text("Quiz Finished!")
                .font(.largeTitle)
            
            Text("You scored:")
                .font(.headline)
            
            Text("\(score) / \(totalQuestions)")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundColor(score >= totalQuestions / 2 ? .green : .red)
            
            Button("Review Topic") {
                dismiss() // Pop back to the Topic Detail View
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 20)
        }
        .padding(40)
    }
}
