import SwiftUI

struct SpellingBeeView: View {
    
    // MARK: - Stored properties
    
    /// The view model that manages the game state.
    @State var viewModel = SpellingBeeViewModel(puzzle: examplePuzzle)
    
    // MARK: - Computed properties
    
    var body: some View {
        VStack(spacing: 20) {
            // Header: Score and Rating
            HStack {
                VStack(alignment: .leading) {
                    Text("Rating: \(viewModel.currentRating)")
                        .font(.headline)
                    Text("Score: \(viewModel.score)")
                        .font(.subheadline)
                }
                Spacer()
            }
            .padding()
            
            Spacer()
            
            // The typed word display
            Text(viewModel.currentWord.isEmpty ? " " : viewModel.currentWord.uppercased())
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .tracking(2)
            
            // Feedback message
            Text(viewModel.message)
                .font(.headline)
                .foregroundStyle(.secondary)
                .frame(height: 30)
            
            Spacer()
            
            // TODO: Add Honeycomb Letter Grid
            Text("Honeycomb Grid will go here")
            
            Spacer()
            
            // Controls
            HStack(spacing: 30) {
                Button("Delete") {
                    viewModel.deleteLetter()
                }
                .buttonStyle(.bordered)
                
                Button("Enter") {
                    viewModel.submitWord()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    SpellingBeeView()
}
