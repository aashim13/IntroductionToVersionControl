import SwiftUI

struct TopicDetailView: View {
    
    // The topic passed from the HomeView. We keep this local copy.
    let topic: Topic
    
    // The central source of truth for all data.
    @EnvironmentObject var dataManager: DataManager
    
    // --- State for Editing Flow ---
    @State private var showingEditSheet = false
    @State private var cardToEdit: Flashcard? = nil
    
    // Helper property to get an *editable binding* to the selected card.
    // This is complex, but necessary to update the struct deep inside the ObservableObject array.
    private var editableCardBinding: Binding<Flashcard>? {
        guard let cardToEdit = cardToEdit,
              let topicIndex = dataManager.topics.firstIndex(where: { $0.id == topic.id }),
              let cardIndex = dataManager.topics[topicIndex].flashcards.firstIndex(where: { $0.id == cardToEdit.id }) else {
            return nil
        }
        
        // This is the key: returning a binding that points to the specific card
        // inside the DataManager's array.
        return $dataManager.topics[topicIndex].flashcards[cardIndex]
    }
    
    // Helper to get the current list of flashcards from the DataManager,
    // ensuring the list updates when cards are added or edited.
    private var currentFlashcards: [Flashcard] {
        dataManager.topics.first(where: { $0.id == topic.id })?.flashcards ?? []
    }
    
    var body: some View {
        VStack {
            
            // MARK: - Action Buttons (Fixed Layout - OUTSIDE the List)
            
            HStack {
                // Button to enter Study Mode
                NavigationLink(destination: StudyModeView(topic: topic)) {
                    Label("Study Cards", systemImage: "text.book.closed.fill")
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .foregroundColor(.blue)
                .cornerRadius(10)
                
                // Button to enter Quiz Mode
                NavigationLink(destination: QuizModeView(topic: topic)) {
                    Label("Take a Quiz", systemImage: "questionmark.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .foregroundColor(.orange)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            // MARK: - Flashcard List
            
            List {
                Section("Flashcards (\(currentFlashcards.count))") {
                    ForEach(currentFlashcards) { card in
                        
                        VStack(alignment: .leading) {
                            Text(card.question)
                                .font(.headline)
                            Text(card.answer)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        // 2. Add tap gesture to open the sheet
                        .contentShape(Rectangle()) // Makes the whole row tappable
                        .onTapGesture {
                            self.cardToEdit = card // Select the card
                            self.showingEditSheet = true // Open the sheet
                        }
                    }
                }
                
                // Button for adding a new card
                Button {
                    addNewFlashcard()
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add New Flashcard")
                    }
                }
                .buttonStyle(.borderless) // Ensure it looks like a standard list button
            }
            .listStyle(.plain) // Fixed: Use plain style to prevent layout issues
        }
        .navigationTitle(topic.title)
        
        // If the list of cards is empty, display a message.
        .overlay {
            if currentFlashcards.isEmpty {
                ContentUnavailableView(
                    "No Flashcards Yet",
                    systemImage: "rectangle.portrait.on.rectangle.portrait.fill",
                    description: Text("Add cards to this topic to start studying or quizzing.")
                )
            }
        }
        
        // 3. Present the Edit Sheet
        .sheet(isPresented: $showingEditSheet) {
            // Only present if we successfully got a binding to a card
            if let cardBinding = editableCardBinding {
                FlashcardEditView(card: cardBinding, isPresented: $showingEditSheet)
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func addNewFlashcard() {
        if let index = dataManager.topics.firstIndex(where: { $0.id == topic.id }) {
            // Create the new card with default text
            let newCard = Flashcard(question: "", answer: "")
            
            // Add it to the DataManager
            dataManager.topics[index].flashcards.append(newCard)
            
            // Automatically open the new card for editing right away
            self.cardToEdit = newCard
            self.showingEditSheet = true
        }
    }
}
#Preview {
    // Use one of your sample topics from the DataManager
    let sampleDataManager = DataManager()
    let sampleTopic = sampleDataManager.topics.first! // Get the first sample topic
    
    TopicDetailView(topic: sampleTopic) // Pass the required topic
        .environmentObject(sampleDataManager)
}
