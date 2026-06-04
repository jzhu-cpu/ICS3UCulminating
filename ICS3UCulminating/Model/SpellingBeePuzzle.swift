import Foundation

// MARK: - MODEL
struct SpellingBeePuzzle {
    let centerLetter: String
    let outerLetters: [String]
    let validWords: [String]
    
    /// NEW: A list of 3-letter words specifically for Junior Mode.
    /// In a standard game, these wouldn't count, but in Junior Mode they do!
    let juniorWords: [String]
    
    // MARK: - Computed properties
    
    var allLetters: [String] {
        var letters = outerLetters
        letters.append(centerLetter)
        return letters
    }
}

// MARK: - DATA COLLECTION
let allPuzzles = [
    
    // Puzzle 1: Center 'L'
    SpellingBeePuzzle(
        centerLetter: "l",
        outerLetters: ["a", "c", "e", "i", "n", "t"],
        validWords: [
            "alec", "alien", "aline", "allele", "anally", "atilt", "canal", "canilla", "cell", "cella", "cellae", "cellar", "clat", "clean", "cleat", "client", "cline", "elate", "elation", "entail", "ileac", "ileal", "inlet", "lace", "lacier", "lacuna", "laic", "lain", "lance", "lancet", "lane", "late", "latent", "latilla", "latin", "lean", "lent", "liana", "lice", "lien", "line", "lineal", "linear", "lint", "lintel", "lite", "nail", "natal", "tala", "talc", "tale", "tall", "tali", "teal", "tela", "tell", "tile", "till"
        ],
        juniorWords: ["all", "ace", "ale", "ate", "can", "eat", "ice", "ill", "let", "lie", "nil", "tea", "ten", "tic", "tie", "tin"]
    ),
    
    // Puzzle 2: Center 'R'
    SpellingBeePuzzle(
        centerLetter: "r",
        outerLetters: ["a", "d", "e", "i", "n", "g"],
        validWords: [
            "area", "arena", "arid", "dare", "darer", "darn", "dear", "deaner", "dearie", "deer", "denar", "dinar", "diner", "dire", "drain", "drainer", "drang", "dread", "drear", "earn", "earner", "eager", "eared", "grad", "grade", "grader", "grain", "grained", "grand", "grander", "grange", "greed", "greeder", "green", "greener", "grid", "grin", "grind", "grinder", "irade", "near", "nearer", "radar", "rage", "raged", "rager", "rain", "rained", "rainier", "rand", "rare", "rared", "read", "reader", "reading", "rear", "reared", "redan", "redia", "reed", "reign", "rein", "reined", "rend", "render", "ride", "rider", "ring", "ringed", "ringer"
        ],
        juniorWords: ["air", "and", "are", "dag", "dan", "den", "dig", "din", "ear", "egg", "end", "era", "erg", "gad", "gag", "gar", "gin", "rag", "ran", "red", "rid", "rig"]
    )
]

let examplePuzzle = allPuzzles[0]
