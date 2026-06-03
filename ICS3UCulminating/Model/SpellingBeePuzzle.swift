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
    /// In Spelling Bee, there are always exactly 7 letters (1 center + 6 outer).
    var allLetters: [String] {
        var letters = outerLetters
        letters.append(centerLetter)
        return letters
    }
}

// MARK: - DATA COLLECTION
// An array containing several different puzzles to keep the game fresh.
// Each puzzle below has exactly 1 center letter and 6 outer letters (7 total).
let allPuzzles = [
    
    // Puzzle 1: Center 'L', Others 'A, C, E, I, N, T'
    SpellingBeePuzzle(
        centerLetter: "l",
        outerLetters: ["a", "c", "e", "i", "n", "t"],
        validWords: [
            "alec", "alien", "aline", "allele", "anally", "atilt", "canal", "canilla", "cell", "cella", "cellae", "cellar", "clat", "clean", "cleat", "client", "cline", "elate", "elation", "entail", "ileac", "ileal", "ileitides", "inlet", "lace", "lacier", "lacuna", "laic", "lain", "lance", "lancet", "lane", "late", "latent", "latilla", "latin", "lean", "lent", "liana", "lice", "lien", "line", "lineal", "linear", "lint", "lintel", "lite", "nail", "natal", "tala", "talc", "tale", "tall", "tali", "teal", "tela", "tell", "tile", "till"
        ]
    ),
    
    // Puzzle 2: Center 'R', Others 'A, D, E, I, N, G'
    SpellingBeePuzzle(
        centerLetter: "r",
        outerLetters: ["a", "d", "e", "i", "n", "g"],
        validWords: [
            "area", "arena", "arid", "dare", "darer", "darn", "dear", "deaner", "dearie", "deer", "denar", "dinar", "diner", "dire", "drain", "drainer", "drang", "dread", "drear", "earn", "earner", "eager", "eared", "grad", "grade", "grader", "grain", "grained", "grand", "grander", "grange", "greed", "greeder", "green", "greener", "grid", "grin", "grind", "grinder", "irade", "near", "nearer", "radar", "rage", "raged", "rager", "rain", "rained", "rainier", "rand", "rare", "rared", "read", "reader", "reading", "rear", "reared", "redan", "redia", "reed", "reign", "rein", "reined", "rend", "render", "ride", "rider", "ring", "ringed", "ringer"
        ]
    ),
    
    // Puzzle 3: Center 'N', Others 'A, D, E, I, G, R'
    SpellingBeePuzzle(
        centerLetter: "n",
        outerLetters: ["a", "d", "e", "i", "g", "r"],
        validWords: [
            "again", "aged", "agent", "aider", "airing", "andante", "anear", "anger", "angered", "angina", "anigh", "aria", "arid", "daen", "dang", "danger", "dare", "daring", "darn", "dean", "deanery", "dear", "dearie", "denar", "denari", "denier", "dine", "diner", "ding", "dinger", "dire", "drain", "drainer", "drang", "earn", "earner", "earing", "eider", "ending", "enrage", "enraged", "gadroon", "gain", "gainer", "garden", "gardener", "gnar", "gnat", "grade", "grader", "gradin", "grain", "grained", "grand", "grander", "grange", "grin", "grind", "grinder", "inane", "ingrain", "ingrained", "inion", "inner", "irade", "near", "nearer", "nearing", "nigher", "niner", "rain", "rained", "rainier", "rand", "ranid", "reading", "redan", "reign", "rein", "reined", "rend", "render"
        ]
    )
]

/// A fallback puzzle used only if something goes wrong with the list above.
let examplePuzzle = allPuzzles[0]
