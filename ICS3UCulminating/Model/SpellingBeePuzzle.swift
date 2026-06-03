import Foundation

// MARK: - MODEL
// The Model is a simple container for data. 
// It doesn't "do" anything or change state; it just describes what a puzzle looks like.
struct SpellingBeePuzzle {
    
    // MARK: - Stored properties
    
    /// The required center letter that must be included in every word.
    let centerLetter: String
    
    /// The six other letters surrounding the center.
    let outerLetters: [String]
    
    /// The "answer key" — all valid words that can be found in this specific puzzle.
    let validWords: [String]
    
    // MARK: - Computed properties
    
    /// A helper property that combines the center letter and outer letters into one list.
    /// This is useful when we need to check if a word uses ONLY the allowed letters.
    var allLetters: [String] {
        var letters = outerLetters
        letters.append(centerLetter)
        return letters
    }
}

// MARK: - EXAMPLE DATA
// This is a "hard-coded" puzzle we can use to test our game.
// In a real app, you might load many of these from a JSON file.
let examplePuzzle = SpellingBeePuzzle(
    centerLetter: "c",
    outerLetters: ["a", "b", "e", "l", "n", "t"],
    validWords: [
        "acne", "alec", "ante", "balc", "beak", "beat", "belt", "bent", "beta", "blat", "bleat", "cable", "cane", "cant", "cate", "ceca", "celanet", "cell", "celt", "cent", "clat", "clean", "cleat", "clenvironmental", "enact", "lance", "lace", "lacuna", "latent", "lean", "lent", "table", "tablet", "tacet", "talc"
    ]
)
