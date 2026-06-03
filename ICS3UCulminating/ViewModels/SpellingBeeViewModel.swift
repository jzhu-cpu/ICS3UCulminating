import Foundation
import Observation

// VIEW MODEL
@Observable
class SpellingBeeViewModel {
    
    // MARK: - Stored properties
    
    /// The current puzzle being played.
    var puzzle: SpellingBeePuzzle
    
    /// The letters currently typed by the user.
    var currentWord: String = ""
    
    /// The list of words the player has successfully found.
    var foundWords: [String] = []
    
    /// The current total score of the player.
    var score: Int = 0
    
    /// Feedback message for the user (e.g., "Pangram!", "Too short").
    var message: String = ""
    
    // MARK: - Computed properties
    
    /// Calculates the maximum possible score for the current puzzle.
    var maximumPossibleScore: Int {
        var total = 0
        for word in puzzle.validWords {
            total += calculateScore(for: word)
        }
        return total
    }
    
    /// Returns the player's rating based on their current score.
    var currentRating: String {
        let maxScore = maximumPossibleScore
        if maxScore == 0 { return "Beginner" }
        
        let percentage = Double(score) / Double(maxScore)
        
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
    
    init(puzzle: SpellingBeePuzzle) {
        self.puzzle = puzzle
    }
    
    // MARK: - Functions
    
    /// Adds a letter to the current word.
    func addLetter(_ letter: String) {
        currentWord += letter.lowercased()
        message = "" // Clear message when typing
    }
    
    /// Removes the last letter from the current word.
    func deleteLetter() {
        if currentWord.isEmpty == false {
            currentWord.removeLast()
        }
        message = ""
    }
    
    /// Attempts to submit the current word.
    func submitWord() {
        let result = validate(word: currentWord)
        
        if result == "Success" {
            foundWords.append(currentWord)
            let wordScore = calculateScore(for: currentWord)
            score += wordScore
            
            if isPangram(word: currentWord) {
                message = "Pangram!"
            } else {
                message = "Nice!"
            }
            currentWord = ""
        } else {
            message = result
        }
    }
    
    /// Validates the word against the game rules.
    func validate(word: String) -> String {
        let normalizedWord = word.lowercased()
        
        // Rule: Already found
        for found in foundWords {
            if found == normalizedWord {
                return "Already found"
            }
        }
        
        // Rule: At least 4 letters
        if normalizedWord.count < 4 {
            return "Too short"
        }
        
        // Rule: Must include center letter
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
        
        // Rule: Must be in the valid word list
        var isValid = false
        for valid in puzzle.validWords {
            if valid.lowercased() == normalizedWord {
                isValid = true
                break
            }
        }
        
        if isValid == false {
            return "Not in word list"
        }
        
        return "Success"
    }
    
    /// Calculates the score for a single valid word.
    func calculateScore(for word: String) -> Int {
        var points = 0
        if word.count == 4 {
            points = 1
        } else if word.count > 4 {
            points = word.count
        }
        
        if isPangram(word: word) {
            points += 7
        }
        return points
    }
    
    /// Determines if a word uses every letter in the hive at least once.
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
