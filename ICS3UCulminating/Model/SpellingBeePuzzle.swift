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

// MARK: - DATA COLLECTION
// An array containing several different puzzles to keep the game fresh.
// When the app starts, we can pick one of these at random.
let allPuzzles = [
    
    // Puzzle 1: Theme is "Cable/Table"
    SpellingBeePuzzle(
        centerLetter: "c",
        outerLetters: ["a", "b", "e", "l", "n", "t"],
        validWords: [
            "acne", "alec", "ante", "balc", "beak", "beat", "belt", "bent", "beta", "blat", "bleat", "cable", "cane", "cant", "cate", "ceca", "celanet", "cell", "celt", "cent", "clat", "clean", "cleat", "clenvironmental", "enact", "lance", "lace", "lacuna", "latent", "lean", "lent", "table", "tablet", "tacet", "talc"
        ]
    ),
    
    // Puzzle 2: Theme is "Reading" (Pangram)
    SpellingBeePuzzle(
        centerLetter: "r",
        outerLetters: ["a", "d", "e", "i", "n", "g"],
        validWords: [
            "area", "arena", "arid", "dare", "dear", "dean", "dearie", "deer", "diner", "dire", "drain", "drang", "dread", "dream", "drear", "earn", "eager", "eared", "grad", "grade", "grain", "grand", "grange", "greed", "green", "grid", "grin", "grind", "irade", "near", "radar", "rage", "raged", "rain", "rained", "rand", "rare", "read", "reading", "rear", "reared", "redan", "reed", "reign", "rein", "reined", "rend", "reredos", "ride", "ring", "ringed"
        ]
    ),
    
    // Puzzle 3: Theme is "Outing" (Pangram)
    SpellingBeePuzzle(
        centerLetter: "o",
        outerLetters: ["u", "t", "i", "n", "g", "s"],
        validWords: [
            "onto", "outgo", "outing", "outings", "oust", "ousting", "snout", "song", "stong", "tong", "tongs"
        ]
    )
]

/// A fallback puzzle used only if something goes wrong with the list above.
let examplePuzzle = allPuzzles[0]
