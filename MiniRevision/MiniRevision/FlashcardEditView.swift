//
//  FlashcardEditView.swift
//  MiniRevision
//
//  Created by Aashi Mehrotra on 11/11/25.
//

import SwiftUI

struct FlashcardEditView: View {
    // 1. Binding to the card for two-way sync
    // When we edit 'card', the change is reflected in the original array.
    @Binding var card: Flashcard
    
    @Binding var isPresented: Bool // To dismiss the sheet
    
    var body: some View {
        NavigationStack {
            Form {
                // New Section for the Image
                Section("Image (SF Symbol Name)") {
                    // We bind the optional String to a TextField
                    TextField("Optional SF Symbol Name (e.g., star.fill)", text: Binding(
                        get: { card.questionImageName ?? "" },
                        set: { card.questionImageName = $0.isEmpty ? nil : $0 }
                    ))
                    // Show a preview if a symbol name is provided
                    if let imageName = card.questionImageName, !imageName.isEmpty {
                        HStack {
                            Image(systemName: imageName)
                                .font(.largeTitle)
                                .foregroundColor(.accentColor)
                            Text("Image Preview")
                        }
                    }
                }
                
                Section("Question (Front of Card)") {
                    // Bind to the card's question property
                    TextEditor(text: $card.question)
                        .background(Color(UIColor(red: 0.855, green: 0.918, blue: 0.961, alpha: 1.0)))                        .frame(minHeight: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Section("Answer (Back of Card)") {
                    // Bind to the card's answer property
                    TextEditor(text: $card.answer)
                        .background(Color(UIColor(red: 0.855, green: 0.918, blue: 0.961, alpha: 1.0)))
                        .frame(minHeight: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .navigationTitle("Edit Flashcard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        isPresented = false // Dismiss the sheet
                    }
                }
            }
        }
    }
}
