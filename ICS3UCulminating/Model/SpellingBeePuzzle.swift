import Foundation

// MARK: - MODEL
struct SpellingBeePuzzle {
    /// INPUT: The required center letter that must be included in every word.
    let centerLetter: String
    
    /// INPUT: The six other letters surrounding the center.
    let outerLetters: [String]
    
    let validWords: [String]
    
    /// NEW: A list of 3-letter words specifically for Junior Mode.
    /// In a standard game, these wouldn't count, but in Junior Mode they do!
    let juniorWords: [String]
    
    // MARK: - Computed properties
    
    /// Combines all 7 letters into one list for validation and drawing.
    var allLetters: [String] {
        var letters = outerLetters
        letters.append(centerLetter)
        return letters
    }
}

// MARK: - DATA COLLECTION
// An array containing many different puzzles to keep the game fun and varied.
let allPuzzles = [
    
    // Puzzle 1
    SpellingBeePuzzle(
        centerLetter: "l",
        outerLetters: ["a", "c", "e", "i", "n", "t"],
        validWords: [
            "alec", "alien", "aline", "allele", "anally", "atilt", "canal", "canilla", "cell", "cella", "cellae", "cellar", "clat", "clean", "cleat", "client", "cline", "elate", "elation", "entail", "ileac", "ileal", "inlet", "lace", "lacier", "lacuna", "laic", "lain", "lance", "lancet", "lane", "late", "latent", "latilla", "latin", "lean", "lent", "liana", "lice", "lien", "line", "lineal", "linear", "lint", "lintel", "lite", "nail", "natal", "tala", "talc", "tale", "tall", "tali", "teal", "tela", "tell", "tile", "till"
        ],
        juniorWords: ["all", "ace", "ale", "ate", "can", "eat", "ice", "ill", "let", "lie", "nil", "tea", "ten", "tic", "tie", "tin"]
    ),
    
    // Puzzle 2
    SpellingBeePuzzle(
        centerLetter: "r",
        outerLetters: ["a", "d", "e", "i", "n", "g"],
        validWords: [
            "area", "arena", "arid", "dare", "darer", "darn", "dear", "deaner", "dearie", "deer", "denar", "dinar", "diner", "dire", "drain", "drainer", "drang", "dread", "drear", "earn", "earner", "eager", "eared", "grad", "grade", "grader", "grain", "grained", "grand", "grander", "grange", "greed", "greeder", "green", "greener", "grid", "grin", "grind", "grinder", "irade", "near", "nearer", "radar", "rage", "raged", "rager", "rain", "rained", "rainier", "rand", "rare", "rared", "read", "reader", "reading", "rear", "reared", "redan", "redia", "reed", "reign", "rein", "reined", "rend", "render", "ride", "rider", "ring", "ringed", "ringer"
        ],
        juniorWords: ["air", "and", "are", "dag", "dan", "den", "dig", "din", "ear", "egg", "end", "era", "erg", "gad", "gag", "gar", "gin", "rag", "ran", "red", "rid", "rig"]
    ),
    
    // Puzzle 3
    SpellingBeePuzzle(
        centerLetter: "h",
        outerLetters: ["a", "l", "p", "y", "i", "g"],
        validWords: ["alpha", "halal", "hall", "hally", "happily", "happy", "high", "highly", "hila", "hill", "hilly", "hiply", "hiya", "hula", "hypha", "hyphal", "phil", "phyla"],
        juniorWords: ["aha", "gap", "gay", "hag", "hip", "lap", "lip", "pal", "pay", "pig", "ply"]
    ),
    
    // Puzzle 4
    SpellingBeePuzzle(
        centerLetter: "m",
        outerLetters: ["a", "n", "g", "r", "o", "i"],
        validWords: ["agma", "amigo", "amir", "amman", "ammo", "ammoniac", "amnia", "amnio", "among", "anima", "gram", "grim", "main", "mama", "mamma", "mana", "manga", "mango", "mania", "manioc", "manna", "mano", "manor", "mara", "margin", "maroon", "mina", "minar", "ming", "minor", "moan", "moira", "moma", "monad", "mong", "mono", "mooning", "moony", "mora", "morn", "morning", "norm", "organigram", "roam", "roaming"],
        juniorWords: ["aim", "ago", "arm", "gag", "gin", "ion", "man", "moo", "nag", "nom", "ram", "rim"]
    ),
    
    // Puzzle 5
    SpellingBeePuzzle(
        centerLetter: "u",
        outerLetters: ["o", "t", "d", "r", "a", "q"],
        validWords: ["about", "around", "aura", "auto", "data", "door", "doubt", "dour", "dura", "outdoor", "outdo", "outroad", "quad", "quart", "quota", "road", "routa", "tatu", "tour", "troad"],
        juniorWords: ["ado", "art", "dot", "oar", "out", "our", "rad", "rod", "rot", "tar", "too"]
    ),
    
    // Puzzle 6
    SpellingBeePuzzle(
        centerLetter: "t",
        outerLetters: ["a", "c", "i", "o", "n", "u"],
        validWords: ["action", "atonic", "auction", "aunt", "cant", "canto", "canton", "cation", "coat", "coati", "conatic", "contact", "cotan", "count", "into", "iota", "natic", "noctua", "nota", "octan", "ontic", "taco", "tacon", "taint", "tonic", "toucan", "toxic", "uncoat", "unit", "untax"],
        juniorWords: ["act", "ant", "can", "cat", "cut", "ion", "nit", "not", "nut", "oat", "tan", "tic", "tin", "ton"]
    )
]

/// A fallback puzzle used only if something goes wrong with the list above.
let examplePuzzle = allPuzzles[0]
