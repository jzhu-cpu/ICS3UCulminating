import SwiftUI

// MARK: - HIVE BACKGROUND VIEW
// This reusable subview creates the signature "Spelling Bee" look.
// It includes the base color and the subtle floating hexagons.
struct HiveBackgroundView: View {
    
    // MARK: - Stored properties
    
    /// Whether or not the background should be in Dark Mode.
    var isDarkMode: Bool = false
    
    // MARK: - Computed properties
    
    var body: some View {
        ZStack {
            // LAYER 1: Base Color
            // Cream in Light Mode, Black in Dark Mode.
            Color(isDarkMode ? .black : Color(red: 255/255, green: 252/255, blue: 230/255))
                .ignoresSafeArea()
            
            // LAYER 2: Floating Hexagons
            // These are subtle icons that give the app a "hive" texture.
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "hexagon")
                        .font(.system(size: 200))
                        .foregroundStyle(.yellow.opacity(0.1))
                        .rotationEffect(.degrees(15))
                        .offset(x: 50, y: -50)
                }
                
                Spacer()
                
                HStack {
                    Image(systemName: "hexagon.fill")
                        .font(.system(size: 150))
                        .foregroundStyle(.yellow.opacity(0.05))
                        .offset(x: -30)
                    Spacer()
                }
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    HiveBackgroundView()
}
