import SwiftUI

// MARK: - VIEW
// The View is the user interface. It draws what the user sees on the screen.
// It observes the View Model and updates whenever the View Model's properties change.
struct SpellingBeeView: View {
    
    // MARK: - Stored properties
    
    /// The instance of the View Model that this view will use.
    /// @State is used here because the View "owns" this data.
    @State var viewModel = SpellingBeeViewModel(puzzle: examplePuzzle)
    
    // MARK: - Computed properties
    
    // This is where the layout is defined
    var body: some View {
        VStack(spacing: 20) {
            
            // SECTION: Header (Rating and Score)
            HStack {
                VStack(alignment: .leading) {
                    Text("Rating: \(viewModel.currentRating)")
                        .font(.headline)
                    Text("Score: \(viewModel.score)")
                        .font(.subheadline)
                }
                Spacer() // Pushes the text to the left
            }
            .padding()
            
            Spacer()
            
            // SECTION: Input Display
            // Shows the word the user is currently building.
            // We use .uppercased() because the game usually shows capital letters.
            Text(viewModel.currentWord.isEmpty ? " " : viewModel.currentWord.uppercased())
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .tracking(2)
            
            // SECTION: Feedback Message
            // Shows results like "Pangram!" or "Too short".
            Text(viewModel.message)
                .font(.headline)
                .foregroundStyle(.secondary)
                .frame(height: 30) // Fixed height prevents the UI from "jumping" when messages appear
            
            Spacer()
            
            // SECTION: Letter Grid
            // TODO: We will build a custom honeycomb shape here later.
            // For now, let's just show a simple grid of buttons for testing.
            let letters = viewModel.puzzle.allLetters
            HStack {
                ForEach(letters, id: \.self) { letter in
                    Button(action: {
                        viewModel.addLetter(letter)
                    }) {
                        Text(letter.uppercased())
                            .font(.title)
                            .frame(width: 44, height: 44)
                            .background(letter == viewModel.puzzle.centerLetter ? Color.yellow : Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
            }
            
            Spacer()
            
            // SECTION: Controls
            HStack(spacing: 30) {
                // Remove the last letter typed
                Button("Delete") {
                    viewModel.deleteLetter()
                }
                .buttonStyle(.bordered)
                
                // Submit the word
                Button("Enter") {
                    viewModel.submitWord()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.bottom, 40)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    SpellingBeeView()
}
