import SwiftUI

// MARK: - VIEW
// The View is the user interface. It draws what the user sees on the screen.
// It watches the View Model and refreshes whenever the game state changes.
struct SpellingBeeView: View {
    
    // MARK: - Stored properties
    
    /// The View Model that manages the game logic.
    /// It starts with a random puzzle by default.
    @State var viewModel = SpellingBeeViewModel()
    
    /// Controls whether the "Found Words" popup sheet is visible.
    @State private var showingWordList = false
    
    // MARK: - Computed properties
    
    var body: some View {
        ZStack {
            // LAYER 1: Background Theme
            // We use a light cream color to match the Spelling Bee aesthetic.
            Color(red: 255/255, green: 252/255, blue: 230/255)
                .ignoresSafeArea()
            
            // LAYER 2: UI Content
            VStack(spacing: 20) {
                
                // SECTION: Top Bar (Score, Refresh, and List)
                HStack {
                    VStack(alignment: .leading) {
                        // Shows the rank (e.g., GENIUS)
                        Text(viewModel.currentRating.uppercased())
                            .font(.system(.caption, design: .monospaced))
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                        
                        // Shows the total numerical score
                        Text("\(viewModel.score)")
                            .font(.system(size: 34, weight: .black, design: .rounded))
                    }
                    
                    Spacer()
                    
                    // ICON: New Game / Refresh
                    // Resets the game with a new random set of letters.
                    Button {
                        viewModel.startNewGame()
                    } label: {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(.black)
                            .padding(.trailing, 10)
                    }
                    
                    // ICON: Found Words List
                    // Toggles a sheet showing all words found so far.
                    Button {
                        showingWordList.toggle()
                    } label: {
                        Image(systemName: "list.bullet.circle.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(.black)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // SECTION: Input Display
                // Shows the word being built in real-time.
                Text(viewModel.currentWord.isEmpty ? " " : viewModel.currentWord.uppercased())
                    .font(.system(size: 44, weight: .black, design: .rounded))
                    .tracking(4)
                    .foregroundStyle(.black)
                
                // SECTION: Feedback Message
                // Shows "Pangram!", "Nice!", or error messages like "Too short".
                Text(viewModel.message)
                    .font(.headline)
                    .foregroundStyle(viewModel.message == "Pangram!" ? .orange : .secondary)
                    .frame(height: 30)
                
                Spacer()
                
                // SECTION: Letter Grid (Honeycomb)
                // We now use our custom HoneycombView instead of a simple grid.
                HoneycombView(viewModel: viewModel)
                
                Spacer()
                
                // SECTION: Controls (Delete and Enter)
                HStack(spacing: 20) {
                    // Button to backspace/delete the last letter
                    Button {
                        viewModel.deleteLetter()
                    } label: {
                        Text("Delete")
                            .font(.headline)
                            .foregroundStyle(.black)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            .background(Capsule().stroke(Color.black, lineWidth: 1))
                    }
                    .buttonStyle(.plain) // Remove system background
                    
                    // Button to submit the word for scoring
                    Button {
                        viewModel.submitWord()
                    } label: {
                        Text("Enter")
                            .font(.headline)
                            .foregroundStyle(.black)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 15)
                            .background(Color.yellow)
                            .clipShape(Capsule())
                            .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
                    }
                    .buttonStyle(.plain) // Remove system background
                }
                .padding(.bottom, 30)
            }
            // Platform specific styling (iOS only)
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
        // POPUP: Found Words Sheet
        .sheet(isPresented: $showingWordList) {
            NavigationStack {
                List(viewModel.foundWords, id: \.self) { word in
                    Text(word.uppercased())
                        .font(.system(.body, design: .monospaced))
                }
                .navigationTitle("Found Words (\(viewModel.foundWords.count))")
                .toolbar {
                    Button("Done") { showingWordList.toggle() }
                }
            }
            // iOS only: Allow the sheet to be half-screen or full-screen
            #if os(iOS)
            .presentationDetents([.medium, .large])
            #endif
        }
    }
}

// MARK: - PREVIEW
#Preview {
    NavigationStack {
        SpellingBeeView()
    }
}
