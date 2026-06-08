import SwiftUI

// MARK: - THEMED SETTINGS VIEW
// This view manages the "Hive Settings" screen.
// We use a ZStack to layer the HiveBackgroundView behind our scrolling content.
struct SettingsView: View {
    
    // MARK: - Stored properties (State)
    // Access global settings from the environment instead of local state
    @Environment(AppSettings.self) private var settings
    
    // Use @Bindable to allow direct binding to the environment object properties
    @State private var settingsWrapper: AppSettings? 
    
    // MARK: - Computed properties
    
    var body: some View {
        // We use @Bindable here to create bindings to the settings object
        @Bindable var settings = settings
        
        ZStack {
            // LAYER 1: Reusable Background
            // We pass the isDarkMode state so the background knows which color to use.
            HiveBackgroundView(isDarkMode: settings.isDarkMode)
            
            // LAYER 2: Scrollable Content
            ScrollView {
                VStack(spacing: 25) {
                    
                    // SECTION: Custom Page Header
                    VStack(spacing: 5) {
                        Image(systemName: "crown.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.yellow)
                        Text("Hive Settings")
                            .font(.system(size: 32, weight: .black, design: .serif))
                            .foregroundStyle(settings.isDarkMode ? .white : .black)
                    }
                    .padding(.top, 20)
                    
                    // SECTION 1: Game Rules
                    // We use our custom "CategoryCard" to group related settings.
                    SettingsCategoryCard(title: "How to Play", isDarkMode: settings.isDarkMode) {
                        NavigationLink(destination: RulesDetailView()) {
                            SettingsRowBeeView(label: "Game Rules", icon: "book.closed.fill", color: .yellow, isDarkMode: settings.isDarkMode)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // SECTION 2: Difficulty Toggles
                    SettingsCategoryCard(title: "Difficulty", isDarkMode: settings.isDarkMode) {
                        SettingsToggleRow(label: "Junior Mode", icon: "person.badge.plus", isOn: $settings.juniorMode, isDarkMode: settings.isDarkMode)
                        Divider().background(Color.yellow.opacity(0.3)) // Subtle line between rows
                        SettingsToggleRow(label: "Show Word Count", icon: "number", isOn: $settings.showWordCount, isDarkMode: settings.isDarkMode)
                    }
                    
                    // SECTION 3: Appearance Toggles
                    SettingsCategoryCard(title: "Appearance", isDarkMode: settings.isDarkMode) {
                        SettingsToggleRow(label: "Dark Mode", icon: "moon.stars.fill", isOn: $settings.isDarkMode, isDarkMode: settings.isDarkMode)
                    }
                    
                    // SECTION 4: Developer Info (About)
                    SettingsCategoryCard(title: "About the Developer", isDarkMode: settings.isDarkMode) {
                        SettingsInfoRow(label: "Developer", value: "Judy Z.", icon: "person.fill", isDarkMode: settings.isDarkMode)
                        Divider().background(Color.yellow.opacity(0.3))
                        SettingsInfoRow(label: "Course", value: "ICS3U Pre-AP", icon: "graduationcap.fill", isDarkMode: settings.isDarkMode)
                    }
                    
                    // ACTION: Reset Button
                    // A specialized button for destructive actions (Resetting data).
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
        .navigationTitle("") // Hide standard navigation title to use our custom header
        .preferredColorScheme(settings.isDarkMode ? .dark : .light)
    }
}

// MARK: - SUBVIEW: CATEGORY CARD
// This is a "Container View". It uses Generics (<Content: View>) so it can wrap around
// any other SwiftUI views we put inside it (like Toggles or NavigationLinks).
struct SettingsCategoryCard<Content: View>: View {
    let title: String
    let isDarkMode: Bool
    let content: Content
    
    // The @ViewBuilder attribute allows us to pass a block of code (the content)
    // when we initialize this struct.
    init(title: String, isDarkMode: Bool, @ViewBuilder content: () -> Content) {
        self.title = title
        self.isDarkMode = isDarkMode
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Group Label (e.g., "DIFFICULTY")
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .padding(.leading, 10)
            
            // The "Card" body
            VStack(spacing: 0) {
                content // This is the block of UI passed in from the parent
            }
            .padding()
            .background(isDarkMode ? Color.gray.opacity(0.2) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                // A thin golden border to match the bee theme
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.yellow.opacity(0.5), lineWidth: 1)
            )
            .shadow(color: .black.opacity(isDarkMode ? 0.3 : 0.05), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - SUBVIEW: ROW DESIGNS
// We use specific subviews for each row type to keep the code organized.

/// A row used for simple navigation (includes a chevron arrow).
struct SettingsRowBeeView: View {
    let label: String
    let icon: String
    let color: Color
    let isDarkMode: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundStyle(.black)
                .frame(width: 36, height: 36)
                .background(Color.yellow)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(label)
                .font(.body)
                .foregroundStyle(isDarkMode ? .white : .black)
            
            Spacer()
            
            Image(systemName: "chevron.right") // Indicates navigation
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }
}

/// A row used for toggle switches (on/off).
struct SettingsToggleRow: View {
    let label: String
    let icon: String
    @Binding var isOn: Bool // @Binding allows this view to change the @State in the parent
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
                .tint(.yellow) // Custom yellow color for the switch
        }
        .padding(.vertical, 8)
    }
}

/// A row used just to display information (no interaction).
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
            
            Text(value) // The actual information text
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - DETAIL VIEW: RULES
// A specialized screen that uses "RuleCards" to explain the game.
struct RulesDetailView: View {
    var body: some View {
        ZStack {
            // Layer the honeycomb background behind the rules
            HiveBackgroundView()
            
            ScrollView {
                VStack(spacing: 25) {
                    
                    // Rule Page Header
                    VStack(spacing: 10) {
                        Image(systemName: "ant.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.yellow)
                            .shadow(radius: 5)
                        
                        Text("How to Play")
                            .font(.system(size: 40, weight: .black, design: .serif))
                    }
                    .padding(.top, 20)
                    
                    // SECTION: The list of rules
                    VStack(spacing: 20) {
                        RuleCard(
                            icon: "hexagon.fill",
                            title: "The Hive",
                            description: "Create words using letters from the hive. You can use any letter as many times as you like!",
                            color: .yellow
                        )
                        
                        RuleCard(
                            icon: "textformat.size",
                            title: "Word Length",
                            description: "Words must contain at least 4 letters to be valid.",
                            color: .orange
                        )
                        
                        RuleCard(
                            icon: "target",
                            title: "The Center Letter",
                            description: "Every word you find MUST include the center letter in the middle of the hive.",
                            color: .red
                        )
                        
                        RuleCard(
                            icon: "star.fill",
                            title: "Scoring",
                            description: "4-letter words are 1 point. Longer words are 1 point per letter.",
                            color: .green
                        )
                        
                        RuleCard(
                            icon: "crown.fill",
                            title: "Pangrams",
                            description: "A word that uses all 7 letters is a 'Pangram' and gives you a 7-point bonus!",
                            color: .purple
                        )
                        
                        RuleCard(
                            icon: "person.badge.plus",
                            title: "Junior Mode",
                            description: "Switch this on in Settings to allow 3-letter words and use a simpler word list!",
                            color: .orange
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Page Footer
                    Text("Good luck, Busy Bee!")
                        .font(.headline)
                        .italic()
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 30)
                }
            }
        }
    }
}

// MARK: - SUBVIEW: RULE CARD
// A custom component that displays a single rule inside a themed card.


// MARK: - PREVIEW
#Preview {
    NavigationStack {
        SettingsView()
    }
}
