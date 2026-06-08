import SwiftUI

// MARK: - VIEW
// This is the main screen where the game is played.
// It brings together all our custom subviews to create the full user interface.
struct SpellingBeeView: View {
    
    // MARK: - Stored properties
    
    // We use @Environment to access the shared AppSettings object.
    // This allows the game screen to instantly react when Dark Mode or Junior Mode is changed in Settings.
    @Environment(AppSettings.self) private var settings
    
    // The ViewModel handles all the "brain" work (logic, scoring, words).
    @State var viewModel = SpellingBeeViewModel()
    
    // Controls the visibility of the popup sheet that shows the full word list.
    @State private var showingWordList = false
    
    /// NEW: A focus state variable.
    /// In SwiftUI, to receive keyboard events, a view must be "focused."
    /// This property lets us tell the app that this screen is the one listening to the user's typing.
    @FocusState private var isFocused: Bool
    
    // MARK: - Computed properties
    
    var body: some View {
        ZStack {
            // LAYER 1: The themed background with floating hexagons.
            HiveBackgroundView(isDarkMode: settings.isDarkMode)
            
            // LAYER 2: The main content stacked vertically.
            VStack(spacing: 20) {
                
                // SUBVIEW 1: The header (Rating, Score, and top buttons).
                GameHeaderView(viewModel: viewModel, showingWordList: $showingWordList, isDarkMode: settings.isDarkMode)
                
                // SUBVIEW 2: The horizontal scroll list of correctly guessed words.
                FoundWordsScrollView(foundWords: viewModel.foundWords, isDarkMode: settings.isDarkMode)
                
                Spacer() // Pushes the next elements toward the middle/bottom
                
                // SUBVIEW 3: Shows the word currently being typed and any feedback messages.
                WordDisplayView(currentWord: viewModel.currentWord, message: viewModel.message, isDarkMode: settings.isDarkMode)
                
                Spacer()
                
                // SUBVIEW 4: The custom honeycomb hexagonal grid of letters.
                HoneycombView(viewModel: viewModel)
                
                Spacer()
                
                // SUBVIEW 5: The Enter and Delete action buttons.
                GameControlsView(viewModel: viewModel, isDarkMode: settings.isDarkMode, juniorMode: settings.juniorMode)
            }
            // iOS-specific modifier to keep the navigation bar small and centered.
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
        // This ensures the entire screen respects the user's Dark Mode preference.
        .preferredColorScheme(settings.isDarkMode ? .dark : .light)
        
        // --- KEYBOARD SUPPORT LOGIC ---
        
        // 1. .focusable() makes this ZStack capable of receiving keyboard input.
        .focusable()
        
        // 2. .focused($isFocused) connects our focus state variable to this view.
        .focused($isFocused)
        
        // 3. .onAppear is called when the screen first opens.
        // We use it here to automatically "click" into the keyboard focus.
        .onAppear {
            isFocused = true
            // Also ensure the ViewModel knows if Junior Mode is on right away.
            viewModel.isJuniorMode = settings.juniorMode
        }
        
        // 4. .onKeyPress captures every key the user hits on a physical keyboard.
        .onKeyPress { keyPress in
            // ACTION: Handle the 'Return' (Enter) key.
            if keyPress.key == .return {
                viewModel.submitWord(juniorMode: settings.juniorMode)
                return .handled // We "handled" the key, so stop looking for other uses for it.
            }
            
            // ACTION: Handle the 'Backspace' (Delete) key.
            if keyPress.key == .delete {
                viewModel.deleteLetter()
                return .handled
            }
            
            // ACTION: Handle letter typing.
            // We convert the character to lowercase to match our game data.
            let typedChar = keyPress.characters.lowercased()
            
            // We only care about single-character letters (no numbers, symbols, etc).
            if typedChar.count == 1 {
                // IMPORTANT RULE: Only allow the character if it exists in the hive!
                if viewModel.isLetterInHive(typedChar) {
                    viewModel.addLetter(typedChar)
                    return .handled
                }
            }
            
            // If the user hit a key we don't care about (like '9' or 'Shift'), we ignore it.
            return .ignored
        }
        
        // This watches the global settings. If you change Junior Mode while the game is open,
        // the ViewModel updates its rules instantly.
        .onChange(of: settings.juniorMode) { old, newValue in
            viewModel.isJuniorMode = newValue
        }
        
        // POPUP: This sheet appears when showingWordList is true.
        .sheet(isPresented: $showingWordList) {
            FoundWordsListView(foundWords: viewModel.foundWords, isShowing: $showingWordList)
        }
    }
}

// MARK: - SUBVIEW: GAME HEADER
struct GameHeaderView: View {
    var viewModel: SpellingBeeViewModel
    @Binding var showingWordList: Bool
    let isDarkMode: Bool
    
    var body: some View {
        HStack {
            // Displays the Rating and the numerical Score.
            VStack(alignment: .leading) {
                HStack(spacing: 8) {
                    Text(viewModel.currentRating.uppercased())
                        .font(.system(.caption, design: .monospaced))
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                    
                    // The orange badge only shows up if Junior Mode is active.
                    if viewModel.isJuniorMode {
                        Text("JUNIOR")
                            .font(.system(size: 10, weight: .black))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.orange)
                            .clipShape(Capsule())
                    }
                }
                
                Text("\(viewModel.score)")
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundStyle(isDarkMode ? .white : .black)
            }
            
            Spacer()
            
            // BUTTON: Start a completely new game with new letters.
            Button {
                viewModel.startNewGame()
            } label: {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(isDarkMode ? .white : .black)
                    .padding(.trailing, 10)
            }
            .buttonStyle(.plain)
            
            // BUTTON: Toggle the full list of found words.
            Button {
                showingWordList.toggle()
            } label: {
                Image(systemName: "list.bullet.circle.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(isDarkMode ? .white : .black)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
    }
}

// MARK: - SUBVIEW: FOUND WORDS SCROLL VIEW
// This subview shows a horizontally scrolling list of all words found so far.
struct FoundWordsScrollView: View {
    let foundWords: [String]
    let isDarkMode: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Label for the section showing the count.
            Text("Words Found: \(foundWords.count)")
                .font(.system(.caption, design: .monospaced))
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
            
            // ScrollView(.horizontal) allows the user to swipe left/right if there are many words.
            // showsIndicators: false hides the scroll bar at the bottom for a cleaner look.
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    if foundWords.isEmpty {
                        // Helpful text for new players.
                        Text("Start typing to find words!")
                            .font(.subheadline)
                            .italic()
                            .foregroundStyle(.secondary)
                    } else {
                        // Display each word in a small "bubble" (Capsule).
                        // .reversed() ensures the word you JUST found appears first on the left.
                        ForEach(foundWords.reversed(), id: \.self) { word in
                            Text(word.uppercased())
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.bold)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.yellow.opacity(0.2))
                                .foregroundStyle(isDarkMode ? .yellow : .black)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(Color.yellow.opacity(0.5), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 40)
        }
        .padding(.top, 10)
    }
}

// MARK: - SUBVIEW: WORD DISPLAY
// Shows the large text of the word you are currently building.
struct WordDisplayView: View {
    let currentWord: String
    let message: String
    let isDarkMode: Bool
    
    var body: some View {
        VStack {
            // Displays the current word in large, bold letters.
            Text(currentWord.isEmpty ? " " : currentWord.uppercased())
                .font(.system(size: 44, weight: .black, design: .rounded))
                .tracking(4) // Adds extra space between the letters
                .foregroundStyle(isDarkMode ? .white : .black)
            
            // Displays feedback messages like "Pangram!" or "Too short".
            Text(message)
                .font(.headline)
                .foregroundStyle(message == "Pangram!" ? .orange : .secondary)
                .frame(height: 30)
        }
    }
}

// MARK: - SUBVIEW: GAME CONTROLS
struct GameControlsView: View {
    var viewModel: SpellingBeeViewModel
    let isDarkMode: Bool
    let juniorMode: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            // BUTTON: Backspace/Delete
            Button {
                viewModel.deleteLetter()
            } label: {
                Text("Delete")
                    .font(.headline)
                    .foregroundStyle(isDarkMode ? .white : .black)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(Capsule().stroke(isDarkMode ? Color.white : Color.black, lineWidth: 1))
            }
            .buttonStyle(.plain)
            // Keyboard shortcut for the Backspace/Delete key.
            .keyboardShortcut(.delete, modifiers: [])
            
            // BUTTON: Submit the word
            Button {
                viewModel.submitWord(juniorMode: juniorMode)
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
            .buttonStyle(.plain)
            // Keyboard shortcut for the Return/Enter key.
            .keyboardShortcut(.defaultAction)
        }
        .padding(.bottom, 30)
    }
}

// MARK: - SUBVIEW: FOUND WORDS LIST (SHEET)
struct FoundWordsListView: View {
    let foundWords: [String]
    @Binding var isShowing: Bool
    
    var body: some View {
        NavigationStack {
            List(foundWords, id: \.self) { word in
                Text(word.uppercased())
                    .font(.system(.body, design: .monospaced))
            }
            .navigationTitle("Found Words (\(foundWords.count))")
            .toolbar {
                Button("Done") { isShowing.toggle() }
                    .buttonStyle(.plain)
            }
        }
        #if os(iOS)
        .presentationDetents([.medium, .large])
        #endif
    }
}

// MARK: - PREVIEW
#Preview {
    NavigationStack {
        SpellingBeeView()
    }
}
