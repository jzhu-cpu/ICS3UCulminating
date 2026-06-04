import SwiftUI

// MARK: - VIEW
struct SpellingBeeView: View {
    
    // MARK: - Stored properties
    
    // Access the global settings from the environment
    @Environment(AppSettings.self) private var settings
    
    @State var viewModel = SpellingBeeViewModel()
    @State private var showingWordList = false
    
    // MARK: - Computed properties
    var body: some View {
        ZStack {
            // Background (Now using our reusable HiveBackgroundView)
            HiveBackgroundView(isDarkMode: settings.isDarkMode)
            
            VStack(spacing: 20) {
                
                // SUBVIEW: Top Bar (Organized into its own section below)
                GameHeaderView(viewModel: viewModel, showingWordList: $showingWordList, isDarkMode: settings.isDarkMode)
                
                Spacer()
                
                // SUBVIEW: Word Display
                WordDisplayView(currentWord: viewModel.currentWord, message: viewModel.message, isDarkMode: settings.isDarkMode)
                
                Spacer()
                
                // SUBVIEW: Honeycomb Grid (Already a separate file!)
                HoneycombView(viewModel: viewModel)
                
                Spacer()
                
                // SUBVIEW: Action Buttons
                GameControlsView(viewModel: viewModel, isDarkMode: settings.isDarkMode)
            }
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
        .preferredColorScheme(settings.isDarkMode ? .dark : .light)
        // POPUP: Found Words Sheet
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
            VStack(alignment: .leading) {
                Text(viewModel.currentRating.uppercased())
                    .font(.system(.caption, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                
                Text("\(viewModel.score)")
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundStyle(isDarkMode ? .white : .black)
            }
            
            Spacer()
            
            Button {
                viewModel.startNewGame()
            } label: {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(isDarkMode ? .white : .black)
                    .padding(.trailing, 10)
            }
            .buttonStyle(.plain)
            
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

// MARK: - SUBVIEW: WORD DISPLAY
struct WordDisplayView: View {
    let currentWord: String
    let message: String
    let isDarkMode: Bool
    
    var body: some View {
        VStack {
            Text(currentWord.isEmpty ? " " : currentWord.uppercased())
                .font(.system(size: 44, weight: .black, design: .rounded))
                .tracking(4)
                .foregroundStyle(isDarkMode ? .white : .black)
            
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
    
    var body: some View {
        HStack(spacing: 20) {
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
            .buttonStyle(.plain)
        }
        .padding(.bottom, 30)
    }
}

// MARK: - SUBVIEW: FOUND WORDS LIST
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
