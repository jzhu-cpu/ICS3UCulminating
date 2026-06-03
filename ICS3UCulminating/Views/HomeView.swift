import SwiftUI

// MARK: - HOME VIEW
// This is the first screen the user sees when they launch the app.
// It provides a "hub" for navigating to the game or settings.
struct HomeView: View {
    
    // MARK: - Computed properties
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color theme (light yellow/cream)
                Color(red: 255/255, green: 252/255, blue: 230/255)
                    .ignoresSafeArea()
                
                VStack(spacing: 50) {
                    
                    // SECTION: Header/Logo
                    VStack(spacing: 10) {
                        // A simple "bee" icon or circle to represent the game
                        Image(systemName: "hexagon.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.yellow)
                            .overlay {
                                Image(systemName: "ant.fill") // Using an insect icon as a "bee"
                                    .font(.title)
                                    .foregroundStyle(.black)
                            }
                            .shadow(radius: 5)
                        
                        Text("Spelling Bee")
                            .font(.system(size: 48, weight: .black, design: .serif))
                            .foregroundStyle(.black)
                        
                        Text("Build words, earn points.")
                            .font(.subheadline)
                            .italic()
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    // SECTION: Navigation Buttons
                    VStack(spacing: 20) {
                        
                        // Navigate to the main game
                        NavigationLink(destination: SpellingBeeView()) {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("Play Game")
                            }
                            .font(.headline)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 5)
                        }
                        
                        // Navigate to settings
                        NavigationLink(destination: SettingsView()) {
                            HStack {
                                Image(systemName: "gearshape.fill")
                                Text("Settings")
                            }
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 5)
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    // Footer
                    Text("© 2026 Judy's Coding Lab")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 10)
                }
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    HomeView()
}
