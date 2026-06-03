import SwiftUI

// MARK: - HEXAGON SHAPE
// This custom shape draws a hexagon (6-sided polygon) using geometric paths.
// We use this for our Spelling Bee "honeycomb" buttons.
struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Calculate the center and the radius of the hexagon
        let width = rect.width
        let height = rect.height
        let xCenter = width / 2
        let yCenter = height / 2
        let radius = min(width, height) / 2
        
        // A hexagon has 6 corners. We calculate the (x, y) position of each.
        // We start at 0 degrees and move in 60-degree increments (2π / 6).
        for i in 0..<6 {
            let angle = CGFloat(i) * .pi / 3
            let x = xCenter + radius * cos(angle)
            let y = yCenter + radius * sin(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.closeSubpath()
        return path
    }
}

// MARK: - HONEYCOMB VIEW
// This view arranges the 7 letter buttons in a hexagonal grid pattern.
struct HoneycombView: View {
    
    // MARK: - Stored properties
    
    /// The View Model that handles the game state.
    var viewModel: SpellingBeeViewModel
    
    /// The size of a single hexagon button.
    let hexSize: CGFloat = 100
    
    // MARK: - Computed properties
    
    var body: some View {
        ZStack {
            // 1. THE CENTER BUTTON
            // This is the required letter in the middle.
            HexButton(
                letter: viewModel.puzzle.centerLetter,
                color: .yellow,
                action: { viewModel.addLetter(viewModel.puzzle.centerLetter) }
            )
            
            // 2. THE OUTER BUTTONS
            // We loop through the 6 outer letters and place them around the center.
            ForEach(0..<viewModel.puzzle.outerLetters.count, id: \.self) { index in
                let letter = viewModel.puzzle.outerLetters[index]
                
                // We use trigonometry (sin/cos) to calculate the (x, y) offset for each button.
                // We space them 60 degrees apart in a circle.
                let angle = CGFloat(index) * .pi / 3 - .pi / 2
                let xOffset = cos(angle) * (hexSize * 0.9) // Distance from center
                let yOffset = sin(angle) * (hexSize * 0.9)
                
                HexButton(
                    letter: letter,
                    color: .white,
                    action: { viewModel.addLetter(letter) }
                )
                .offset(x: xOffset, y: yOffset)
            }
        }
        .frame(width: hexSize * 3, height: hexSize * 3)
    }
}

// MARK: - HEXAGON BUTTON
// A reusable component that represents a single letter in the honeycomb.
struct HexButton: View {
    let letter: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(letter.uppercased())
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(.black)
                .frame(width: 100, height: 100)
                .background(Hexagon().fill(color))
                .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 3)
        }
        // This modifier removes the default "gray box" background that 
        // some platforms (like macOS or newer iOS versions) add to buttons.
        .buttonStyle(.plain)
    }
}

// MARK: - PREVIEW
#Preview {
    ZStack {
        Color.gray.opacity(0.1).ignoresSafeArea()
        HoneycombView(viewModel: SpellingBeeViewModel(puzzle: examplePuzzle))
    }
}
