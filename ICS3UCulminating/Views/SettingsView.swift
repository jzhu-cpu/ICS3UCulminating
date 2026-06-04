import SwiftUI

// MARK: - THEMED SETTINGS VIEW
// This redesigned version moves away from standard "Lists" to create a custom
// "Hive" look that matches the Spelling Bee theme.
struct SettingsView: View {
    
    // MARK: - Stored properties (State)
    @State private var isDarkMode = false
    @State private var showWordCount = true
    @State private var juniorMode = false
    
    // MARK: - Computed properties
    
    var body: some View {
        ZStack {
            // Background (Now using our reusable HiveBackgroundView)
            HiveBackgroundView(isDarkMode: isDarkMode)
            
            // Content
            ScrollView {
                VStack(spacing: 25) {
                    
                    // CUSTOM HEADER
                    VStack(spacing: 5) {
                        Image(systemName: "crown.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.yellow)
                        Text("Hive Settings")
                            .font(.system(size: 32, weight: .black, design: .serif))
                            .foregroundStyle(isDarkMode ? .white : .black)
                    }
                    .padding(.top, 20)
                    
                    // SECTION 1: Game Rules
                    SettingsCategoryCard(title: "How to Play", isDarkMode: isDarkMode) {
                        NavigationLink(destination: RulesDetailView()) {
                            SettingsRowBeeView(label: "Game Rules", icon: "book.closed.fill", color: .yellow, isDarkMode: isDarkMode)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // SECTION 2: Difficulty
                    SettingsCategoryCard(title: "Difficulty", isDarkMode: isDarkMode) {
                        SettingsToggleRow(label: "Junior Mode", icon: "person.badge.plus", isOn: $juniorMode, isDarkMode: isDarkMode)
                        Divider().background(Color.yellow.opacity(0.3))
                        SettingsToggleRow(label: "Show Word Count", icon: "number", isOn: $showWordCount, isDarkMode: isDarkMode)
                    }
                    
                    // SECTION 3: Appearance
                    SettingsCategoryCard(title: "Appearance", isDarkMode: isDarkMode) {
                        SettingsToggleRow(label: "Dark Mode", icon: "moon.stars.fill", isOn: $isDarkMode, isDarkMode: isDarkMode)
                    }
                    
                    // SECTION 4: About
                    SettingsCategoryCard(title: "About the Developer", isDarkMode: isDarkMode) {
                        SettingsInfoRow(label: "Developer", value: "Judy Z.", icon: "person.fill", isDarkMode: isDarkMode)
                        Divider().background(Color.yellow.opacity(0.3))
                        SettingsInfoRow(label: "Course", value: "ICS3U Pre-AP", icon: "graduationcap.fill", isDarkMode: isDarkMode)
                    }
                    
                    // RESET BUTTON
                    Button(action: { print("Resetting...") }) {
                        Text("Reset All Progress")
                            .font(.headline)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).stroke(Color.red, lineWidth: 2))
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationTitle("") // Hide standard title to use our custom one
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

// MARK: - SUBVIEW: CATEGORY CARD
// A custom card that looks like a cell in a honeycomb hive.
struct SettingsCategoryCard<Content: View>: View {
    let title: String
    let isDarkMode: Bool
    let content: Content
    
    init(title: String, isDarkMode: Bool, @ViewBuilder content: () -> Content) {
        self.title = title
        self.isDarkMode = isDarkMode
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .padding(.leading, 10)
            
            VStack(spacing: 0) {
                content
            }
            .padding()
            .background(isDarkMode ? Color.gray.opacity(0.2) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.yellow.opacity(0.5), lineWidth: 1)
            )
            .shadow(color: .black.opacity(isDarkMode ? 0.3 : 0.05), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - SUBVIEW: ROW DESIGN
struct SettingsRowBeeView: View {
    let label: String
    let icon: String
    let color: Color
    let isDarkMode: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            // Icon in a small Hexagon-like rounded square
            Image(systemName: icon)
                .foregroundStyle(.black)
                .frame(width: 36, height: 36)
                .background(Color.yellow)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(label)
                .font(.body)
                .foregroundStyle(isDarkMode ? .white : .black)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct SettingsToggleRow: View {
    let label: String
    let icon: String
    @Binding var isOn: Bool
    let isDarkMode: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundStyle(.black)
                .frame(width: 36, height: 36)
                .background(Color.yellow.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(label)
                .font(.body)
                .foregroundStyle(isDarkMode ? .white : .black)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .tint(.yellow) // Makes the toggle "Bee" colored!
        }
        .padding(.vertical, 8)
    }
}

struct SettingsInfoRow: View {
    let label: String
    let value: String
    let icon: String
    let isDarkMode: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundStyle(.black)
                .frame(width: 36, height: 36)
                .background(Color.yellow.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(label)
                .font(.body)
                .foregroundStyle(isDarkMode ? .white : .black)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - PREVIEW
#Preview {
    NavigationStack {
        SettingsView()
    }
}
// MARK: - DETAIL VIEW: RULES
// This is the screen that shows the actual game instructions.
struct RulesDetailView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Spelling Bee Rules")
                    .font(.largeTitle)
                    .fontWeight(.black)
                
                RulePoint(title: "The Goal", description: "Create as many words as you can using letters from the hive.")
                
                RulePoint(title: "Word Length", description: "Words must contain at least 4 letters.")
                
                RulePoint(title: "The Center Letter", description: "Every word you find MUST include the center letter (the yellow one).")
                
                RulePoint(title: "Scoring", description: "4-letter words are worth 1 point. Longer words earn 1 point per letter.")
                
                RulePoint(title: "Pangrams", description: "A word that uses all 7 letters is a 'Pangram' and gives you a 7-point bonus!")
                
                RulePoint(title: "Repeat Letters", description: "You can use the same letter as many times as you want in a single word.")
            }
            .padding()
        }
        .navigationTitle("Rules")
        .background(Color(red: 255/255, green: 252/255, blue: 230/255))
    }
}

// Helper for the Rules Detail View
struct RulePoint: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.black)
            Text(description)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 5)
    }
}

