import SwiftUI

// MARK: - MENU ITEM MODEL
// A simple struct to hold the data for our home screen buttons.
// This allows us to organize our buttons in an array.
struct HomeMenuItem {
    let title: String
    let icon: String
    let backgroundColor: Color
    let textColor: Color
}

// MARK: - HOME VIEW
struct HomeView: View {
    
    // MARK: - Stored properties
    
    // Access the global settings from the environment
    @Environment(AppSettings.self) private var settings
    
    /// An array of menu items. This "organizes the code" by separating the data from the layout.
    let menuItems = [
        HomeMenuItem(title: "Play Game", icon: "play.fill", backgroundColor: .yellow, textColor: .black),
        HomeMenuItem(title: "Settings", icon: "gearshape.fill", backgroundColor: .black, textColor: .white)
    ]
    
    // MARK: - Computed properties
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background (Now using our reusable HiveBackgroundView)
                HiveBackgroundView(isDarkMode: settings.isDarkMode)
                
                VStack(spacing: 50) {
                    
                    // SECTION: Header
                    HeaderView(isDarkMode: settings.isDarkMode)
                    
                    Spacer()
                    
                    // SECTION: Navigation Buttons (Organized using an array)
                    VStack(spacing: 20) {
                        // We loop through our array of data to create the buttons
                        ForEach(menuItems, id: \.title) { item in
                            if item.title == "Play Game" {
                                NavigationLink(destination: SpellingBeeView()) {
                                    MenuButtonView(item: item)
                                }
                                .buttonStyle(.plain)
                            } else {
                                NavigationLink(destination: SettingsView()) {
                                    MenuButtonView(item: item)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    Text("© 2026 Judy's Coding Lab")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 10)
                }
            }
        }
        .preferredColorScheme(settings.isDarkMode ? .dark : .light)
    }
}

// MARK: - SUBVIEW: HEADER
// A custom subview for the top part of the home screen.
struct HeaderView: View {
    let isDarkMode: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "hexagon.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundStyle(.yellow)
                .overlay {
                    Image(systemName: "ant.fill")
                        .font(.title)
                        .foregroundStyle(.black)
                }
                .shadow(radius: 5)
            
            Text("Spelling Bee")
                .font(.system(size: 48, weight: .black, design: .serif))
                .foregroundStyle(isDarkMode ? .white : .black)
            
            Text("Build words, earn points.")
                .font(.subheadline)
                .italic()
                .foregroundStyle(.secondary)
        }
        .padding(.top, 40)
    }
}

// MARK: - SUBVIEW: MENU BUTTON
// A custom subview that defines how each button in our menu should look.
struct MenuButtonView: View {
    let item: HomeMenuItem
    
    var body: some View {
        HStack {
            Image(systemName: item.icon)
            Text(item.title)
        }
        .font(.headline)
        .foregroundStyle(item.textColor)
        .frame(maxWidth: .infinity)
        .padding()
        .background(item.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 5)
    }
}

// MARK: - PREVIEW
#Preview {
    HomeView()
}
