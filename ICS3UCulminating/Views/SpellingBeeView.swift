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
                
                // SECTION: Letter Grid
                // This grid creates buttons for all 7 letters in the puzzle.
                let letters = viewModel.puzzle.allLetters
                LazyVGrid(columns: [GridItem(.fixed(60)), GridItem(.fixed(60)), GridItem(.fixed(60))], spacing: 15) {
                    ForEach(letters, id: \.self) { letter in
                        Button(action: {
                            viewModel.addLetter(letter)
                        }) {
                            Text(letter.uppercased())
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .frame(width: 60, height: 60)
                                // The center letter gets a Yellow background, others are White.
                                .background(letter == viewModel.puzzle.centerLetter ? Color.yellow : Color.white)
                                .foregroundStyle(.black)
                                .clipShape(Circle())
                                .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 2)
                        }
                    }
                }
                
                Spacer()
                
                // SECTION: Controls (Delete and Enter)
                HStack(spacing: 20) {
                    // Button to backspace/delete the last letter
                    Button("Delete") {
                        viewModel.deleteLetter()
                    }
                    .font(.headline)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(Capsule().stroke(Color.black, lineWidth: 1))
                    
                    // Button to submit the word for scoring
                    Button("Enter") {
                        viewModel.submitWord()
                    }
                    .font(.headline)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
                    .background(Color.yellow)
                    .clipShape(Capsule())
                    .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
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
