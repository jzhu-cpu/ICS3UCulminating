import SwiftUI

// MARK: - SETTINGS VIEW
// This is a placeholder screen for app settings.
// We can expand this later with options like "Dark Mode" or "Difficulty".
struct SettingsView: View {
    var body: some View {
        List {
            Section(header: Text("Game Preferences")) {
                Text("Sound Effects")
                Text("Haptic Feedback")
            }
            
            Section(header: Text("About")) {
                Text("Version 1.0.0")
                Text("Created for Pre-AP Computer Science")
            }
        }
        .navigationTitle("Settings")
    }
}

// MARK: - PREVIEW
#Preview {
    NavigationStack {
        SettingsView()
    }
}
