import Foundation
import Observation

// MARK: - VIEW MODEL
// The View Model is the "brain" of the app.
// It manages the active game state and handles user interaction logic.
// We use the @Observable macro so the SwiftUI View knows when to refresh the screen.
@Observable
class SpellingBeeViewModel {
    
    // MARK: - Stored properties (State)
    // These properties represent the "current status" of the game.
    
    /// The specific puzzle data (letters and valid words) currently being played.
    var puzzle: SpellingBeePuzzle
    
    /// The string of letters the user is currently typing.
    var currentWord: String = ""
    
    /// An array of words the player has already successfully submitted.
    var foundWords: [String] = []
    
    /// The player's current total score.
    var score: Int = 0
    
    /// A message to show the user, like "Nice!", "Pangram!", or "Too short".
    var message: String = ""
    
    /// NEW: Whether Junior Mode is active (allows 3-letter words).
    var isJuniorMode: Bool = false
    
    // MARK: - Computed properties
    // These values are calculated "on the fly" whenever they are needed.
    
    /// Derives the maximum possible score by summing up the value of every valid word in the puzzle.
    var maximumPossibleScore: Int {
        var total = 0
        for word in puzzle.validWords {
            total += calculateScore(for: word)
        }
        return total
    }
    
    /// Determines the player's rank (e.g., "Beginner", "Genius") based on the percentage of the total score earned.
    var currentRating: String {
        let maxScore = maximumPossibleScore
        if maxScore == 0 { return "Beginner" }
        
        // Calculate what percentage of the total words they have found (0.0 to 1.0)
        let percentage = Double(score) / Double(maxScore)
        
        // Thresholds based on typical Spelling Bee game design
        if percentage >= 1.0 {
            return "Queen Bee"
        } else if percentage >= 0.70 {
            return "Genius"
        } else if percentage >= 0.50 {
            return "Amazing"
        } else if percentage >= 0.40 {
            return "Nice"
        } else if percentage >= 0.25 {
            return "Solid"
        } else if percentage >= 0.15 {
            return "Good"
        } else if percentage >= 0.08 {
            return "Moving Up"
        } else if percentage >= 0.05 {
            return "Good Start"
        } else {
            return "Beginner"
        }
    }
    
    // MARK: - Initializer
    
    /// Sets up the View Model.
    /// - Parameter puzzle: An optional puzzle. If nil, a random puzzle is chosen from our collection.
    init(puzzle: SpellingBeePuzzle? = nil) {
        if let providedPuzzle = puzzle {
            // Use the specific puzzle if one was given
            self.puzzle = providedPuzzle
        } else {
            // Use .randomElement() to pick a random puzzle from the allPuzzles array.
            // If the array was empty, we provide a fallback (allPuzzles[0]).
            self.puzzle = allPuzzles.randomElement() ?? allPuzzles[0]
        }
    }
    
    // MARK: - Functions (User Intent)
    // These functions are called by the View when the user interacts with the UI.
    
    /// Resets the game state and picks a new random puzzle from the list.
    func startNewGame() {
        // 1. Pick a new random puzzle
        self.puzzle = allPuzzles.randomElement() ?? allPuzzles[0]
        
        // 2. Clear all progress from the previous game
        currentWord = ""
        foundWords = []
        score = 0
        message = "New Game Started!"
    }
    
    /// Adds a letter to the current typed word.
    func addLetter(_ letter: String) {
        currentWord += letter.lowercased()
        message = "" // Clear the message so the user can see fresh feedback later
    }
    
    /// Deletes the last character from the current word.
    func deleteLetter() {
        if currentWord.isEmpty == false {
            currentWord.removeLast()
        }
        message = ""
    }
    
    /// Logic for when the user submits a word.
    /// - Parameter juniorMode: Whether or not to apply easier rules.
    func submitWord(juniorMode: Bool = false) {
        // Step 1: Validate the word rules
        let result = validate(word: currentWord, juniorMode: juniorMode)
        
        // Step 2: If valid, update state
        if result == "Success" {
            foundWords.append(currentWord)
            
            // Calculate points
            let wordScore = calculateScore(for: currentWord)
            score += wordScore
            
            // Special feedback for Pangrams
            if isPangram(word: currentWord) {
                message = "Pangram!"
            } else {
                message = "Nice!"
            }
            
            // Clear input for the next word
            currentWord = ""
        } else {
            // Step 3: Show error message
            message = result
        }
    }
    
    // MARK: - Private Helpers
    // These functions handle the "rules" of the game logic.
    
    /// Checks a word against all Spelling Bee rules.
    func validate(word: String, juniorMode: Bool) -> String {
        let normalizedWord = word.lowercased()
        
        // Rule: Can't submit the same word twice
        for found in foundWords {
            if found == normalizedWord {
                return "Already found"
            }
        }
        
        // Rule: Length check (Junior mode allows 3 letters, Standard requires 4)
        let minLength = juniorMode ? 3 : 4
        if normalizedWord.count < minLength {
            return "Too short"
        }
        
        // Rule: Must use the center letter
        var containsCenterLetter = false
        for character in normalizedWord {
            if String(character) == puzzle.centerLetter.lowercased() {
                containsCenterLetter = true
                break
            }
        }
        
        if containsCenterLetter == false {
            return "Missing center letter"
        }
        
        // Rule: Check if it's in the valid words list
        var isValid = false
        
        // Check standard words
        for valid in puzzle.validWords {
            if valid.lowercased() == normalizedWord {
                isValid = true
                break
            }
        }
        
        // If not found yet and in Junior Mode, check the junior words
        if isValid == false && juniorMode == true {
            for junior in puzzle.juniorWords {
                if junior.lowercased() == normalizedWord {
                    isValid = true
                    break
                }
            }
        }
        
        if isValid == false {
            return "Not in word list"
        }
        
        return "Success"
    }
    
    /// Calculates score: 3-4 letters = 1pt, 5+ letters = 1pt per letter, Pangram = +7pts.
    func calculateScore(for word: String) -> Int {
        var points = 0
        if word.count <= 4 {
            points = 1
        } else if word.count > 4 {
            points = word.count
        }
        
        if isPangram(word: word) {
            points += 7
        }
        return points
    }
    
    /// Checks if a word uses every letter in the hive at least once.
    func isPangram(word: String) -> Bool {
        let normalizedWord = word.lowercased()
        let hiveLetters = puzzle.allLetters
        
        for hiveLetter in hiveLetters {
            var letterFound = false
            for character in normalizedWord {
                if String(character) == hiveLetter.lowercased() {
                    letterFound = true
                    break
                }
            }
            if letterFound == false {
                return false
            }
        }
        return true
    }
}
