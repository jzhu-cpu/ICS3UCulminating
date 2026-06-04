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
    // Pangram example: CLIENTELE, ELATINE
    SpellingBeePuzzle(
        centerLetter: "l",
        outerLetters: ["a", "c", "e", "i", "n", "t"],
        validWords: [
            "alec", "alien", "aline", "allele", "anally", "atilt", "canal", "canilla", "cell", "cella", "cellae", "cellar", "clat", "clean", "cleat", "client", "cline", "elate", "elation", "entail", "ileac", "ileal", "inlet", "lace", "lacier", "lacuna", "laic", "lain", "lance", "lancet", "lane", "late", "latent", "latilla", "latin", "lean", "lent", "liana", "lice", "lien", "line", "lineal", "linear", "lint", "lintel", "lite", "nail", "natal", "tala", "talc", "tale", "tall", "tali", "teal", "tela", "tell", "tile", "till"
        ]
    ),
    
    // Puzzle 2: Center 'R', Others 'A, D, E, I, N, G'
    // Pangram example: DRAINAGE, READING
    SpellingBeePuzzle(
        centerLetter: "r",
        outerLetters: ["a", "d", "e", "i", "n", "g"],
        validWords: [
            "area", "arena", "arid", "dare", "darer", "darn", "dear", "deaner", "dearie", "deer", "denar", "dinar", "diner", "dire", "drain", "drainer", "drang", "dread", "drear", "earn", "earner", "eager", "eared", "grad", "grade", "grader", "grain", "grained", "grand", "grander", "grange", "greed", "greeder", "green", "greener", "grid", "grin", "grind", "grinder", "irade", "near", "nearer", "radar", "rage", "raged", "rager", "rain", "rained", "rainier", "rand", "rare", "rared", "read", "reader", "reading", "rear", "reared", "redan", "redia", "reed", "reign", "rein", "reined", "rend", "render", "ride", "rider", "ring", "ringed", "ringer"
        ]
    ),
    
    // Puzzle 3: Center 'H', Others 'A, L, P, Y, I, L' -> 'A, L, P, Y, I, G' (Fixing for 7 unique)
    // Pangram: HAPPILY
    SpellingBeePuzzle(
        centerLetter: "h",
        outerLetters: ["a", "l", "p", "y", "i", "g"],
        validWords: ["alpha", "halal", "hall", "hally", "happily", "happy", "high", "highly", "hila", "hill", "hilly", "hiply", "hiya", "hula", "hypha", "hyphal", "phil", "phyla"]
    ),
    
    // Puzzle 4: Center 'M', Others 'A, N, O, R, G, I'
    // Pangram: MARJORAM (Needs J), let's try Center 'M', Others 'A, N, G, R, O, I'
    // Pangram: AMORINI (Needs more), let's try Center 'M', Others 'A, N, G, R, O, I'
    // Pangram: ORGANIGRAM
    SpellingBeePuzzle(
        centerLetter: "m",
        outerLetters: ["a", "n", "g", "r", "o", "i"],
        validWords: ["agma", "amigo", "amin", "amir", "amman", "ammo", "ammoniac", "amnia", "amnio", "amniogram", "among", "anima", "gram", "grim", "main", "mama", "mamma", "mammogram", "mana", "manga", "mango", "mania", "manioc", "manna", "mano", "manor", "mara", "marg", "margin", "marmon", "maroon", "mina", "minar", "ming", "minor", "moan", "moira", "moma", "monad", "mong", "monocara", "mono", "mooning", "moony", "mora", "morn", "mornin", "morning", "moro", "morn", "norm", "organigram", "roam", "roaming"]
    ),
    
    // Puzzle 5: Center 'U', Others 'B, L, I, O, T, S'
    // Pangram: SOLUBILITY
    SpellingBeePuzzle(
        centerLetter: "u",
        outerLetters: ["b", "l", "i", "o", "t", "s"],
        validWords: ["blub", "blue", "built", "bull", "bullion", "bullit", "busboy", "bust", "lulu", "lust", "outsit", "slub", "slur", "slut", "solubility", "soul", "subsoil", "substility", "suit", "utilitios"]
    )
]

/// A fallback puzzle used only if something goes wrong with the list above.
let examplePuzzle = allPuzzles[0]
