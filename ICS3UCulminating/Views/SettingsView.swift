import SwiftUI

// MARK: - SETTINGS DATA MODELS
// We define a struct to represent a section in our settings.
struct SettingsSection: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let items: [SettingsItem]
}

// We define a struct for individual items within those sections.
struct SettingsItem: Identifiable {
    let id = UUID()
    let label: String
    let icon: String
    let color: Color
    let destination: AnyView // The view this item navigates to
}

// MARK: - SETTINGS VIEW
struct SettingsView: View {
    
    // MARK: - Stored properties
    
    // We organize our settings into an array of sections. 
    // This makes the code very easy to manage and update!
    let sections: [SettingsSection] = [
        
        // Category 1: Rules/Instructions
        SettingsSection(
            title: "How to Play",
            icon: "book.fill",
            items: [
                SettingsItem(
                    label: "Game Rules",
                    icon: "info.circle.fill",
                    color: .blue,
                    destination: AnyView(RulesDetailView())
                )
            ]
        ),
        
        // Category 2: Language and Music
        SettingsSection(
            title: "Preferences",
            icon: "slider.horizontal.3",
            items: [
                SettingsItem(
                    label: "Language",
                    icon: "character.bubble.fill",
                    color: .orange,
                    destination: AnyView(Text("Language Settings Coming Soon"))
                ),
                SettingsItem(
                    label: "Music & Sounds",
                    icon: "music.note",
                    color: .purple,
                    destination: AnyView(Text("Audio Settings Coming Soon"))
                )
            ]
        ),
        
        // Category 3: Contact Us
        SettingsSection(
            title: "Support",
            icon: "envelope.fill",
            items: [
                SettingsItem(
                    label: "Contact Team",
                    icon: "person.fill.questionmark",
                    color: .green,
                    destination: AnyView(Text("Contact Form Coming Soon"))
                )
            ]
        )
    ]
    
    // MARK: - Computed properties
    
    var body: some View {
        List {
            // We loop through our sections array
            ForEach(sections) { section in
                Section(header: Text(section.title)) {
                    // Inside each section, we loop through the items
                    ForEach(section.items) { item in
                        NavigationLink(destination: item.destination) {
                            SettingsRowView(item: item)
                        }
                        .buttonStyle(.plain) // Ensure no gray boxes!
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .background(Color(red: 255/255, green: 252/255, blue: 230/255))
        .scrollContentBackground(.hidden) // Makes our custom background visible
    }
}

// MARK: - SUBVIEW: SETTINGS ROW
// A reusable view for each row in the settings list.
struct SettingsRowView: View {
    let item: SettingsItem
    
    var body: some View {
        HStack(spacing: 15) {
            // Icon with a colored background
            Image(systemName: item.icon)
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(item.color)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            
            Text(item.label)
                .font(.body)
                .foregroundStyle(.primary)
            
            Spacer()
        }
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

// MARK: - PREVIEW
#Preview {
    NavigationStack {
        SettingsView()
    }
}
