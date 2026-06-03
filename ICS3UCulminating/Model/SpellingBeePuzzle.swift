import Foundation

// MODEL
struct SpellingBeePuzzle {
    
    // MARK: - Stored properties
    
    /// The required center letter that must be included in every word.
    let centerLetter: String
    
    /// The six other letters surrounding the center.
    let outerLetters: [String]
    
    /// All valid words for this specific puzzle.
    let validWords: [String]
    
    // MARK: - Computed properties
    
    /// All seven letters in the puzzle.
    var allLetters: [String] {
        var letters = outerLetters
        letters.append(centerLetter)
        return letters
    }
}

// EXAMPLE PUZZLE
// Letters: C (Center), A, B, E, L, N, T
// Words: table, tablet, catenate, etc.
let examplePuzzle = SpellingBeePuzzle(
    centerLetter: "c",
    outerLetters: ["a", "b", "e", "l", "n", "t"],
    validWords: [
        "acne", "alec", "ante", "balc", "beak", "beat", "belt", "bent", "beta", "blat", "bleat", "cable", "cane", "cant", "cate", "ceca", "celanet", "cell", "celt", "cent", "clat", "clean", "cleat", "clenvironmental", "enact", "lance", "lace", "lacuna", "latent", "lean", "lent", "table", "tablet", "tacet", "talc"
    ]
)
