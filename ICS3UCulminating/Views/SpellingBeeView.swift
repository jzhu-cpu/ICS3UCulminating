import SwiftUI

// MARK: - VIEW
// The View is the user interface. It draws what the user sees on the screen.
struct SpellingBeeView: View {
    
    // MARK: - Stored properties
    
    /// The instance of the View Model that this view will use.
    @State var viewModel = SpellingBeeViewModel()
    
    /// Controls the presentation of the "Found Words" sheet.
    @State private var showingWordList = false
    
    // MARK: - Computed properties
    
    var body: some View {
        ZStack {
            // Background Theme
            Color(red: 255/255, green: 252/255, blue: 230/255)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                // SECTION: Top Bar (Score and List Toggle)
                HStack {
                    VStack(alignment: .leading) {
                        Text(viewModel.currentRating.uppercased())
                            .font(.system(.caption, design: .monospaced))
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                        
                        Text("\(viewModel.score)")
                            .font(.system(size: 34, weight: .black, design: .rounded))
                    }
                    
                    Spacer()
                    
                    // Button to start a new game with different letters
                    Button {
                        viewModel.startNewGame()
                    } label: {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(.black)
                            .padding(.trailing, 10)
                    }
                    
                    // Button to see words already found
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
                Text(viewModel.currentWord.isEmpty ? " " : viewModel.currentWord.uppercased())
                    .font(.system(size: 44, weight: .black, design: .rounded))
                    .tracking(4)
                    .foregroundStyle(.black)
                
                // SECTION: Feedback Message
                Text(viewModel.message)
                    .font(.headline)
                    .foregroundStyle(viewModel.message == "Pangram!" ? .orange : .secondary)
                    .frame(height: 30)
                
                Spacer()
                
                // SECTION: Letter Grid
                // Temporary Grid layout while we prepare the Honeycomb
                let letters = viewModel.puzzle.allLetters
                LazyVGrid(columns: [GridItem(.fixed(60)), GridItem(.fixed(60)), GridItem(.fixed(60))], spacing: 15) {
                    ForEach(letters, id: \.self) { letter in
                        Button(action: {
                            viewModel.addLetter(letter)
                        }) {
                            Text(letter.uppercased())
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .frame(width: 60, height: 60)
                                .background(letter == viewModel.puzzle.centerLetter ? Color.yellow : Color.white)
                                .foregroundStyle(.black)
                                .clipShape(Circle())
                                .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 2)
                        }
                    }
                }
                
                Spacer()
                
                // SECTION: Controls
                HStack(spacing: 20) {
                    Button("Delete") {
                        viewModel.deleteLetter()
                    }
                    .font(.headline)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(Capsule().stroke(Color.black, lineWidth: 1))
                    
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
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
        // A popup sheet to show words found
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
