import Foundation
import Observation

@Observable
class SpellingBeeGame {
    
    // MARK: - Stored properties
    
    /// The seven unique letters available in the hive.
    var hiveLetters: [String] = []
    
    /// The required center letter that must be included in every word.
    var centerLetter: String = ""
    
    /// The list of words the player has successfully found.
    var foundWords: [String] = []
    
    /// The current total score of the player.
    var score: Int = 0
    
    /// All valid words for the current hive (the "answer key").
    var allPossibleWords: [String] = []
    
    // MARK: - Initializer
    
    /// Creates a new game session with a set of letters and the valid word list.
    /// - Parameters:
    ///   - hiveLetters: An array of 7 unique letters.
    ///   - centerLetter: One of the hive letters that must be present in every word.
    ///   - allPossibleWords: The complete list of valid words for this specific hive.
    init(hiveLetters: [String], centerLetter: String, allPossibleWords: [String]) {
        self.hiveLetters = hiveLetters
        self.centerLetter = centerLetter
        self.allPossibleWords = allPossibleWords
    }
    
    // MARK: - Functions
    
    /// Attempts to submit a word and updates the game state if valid.
    /// - Parameter word: The word the player is submitting.
    /// - Returns: A message describing the result of the submission.
    func submit(word: String) -> String {
        let normalizedWord = word.lowercased()
        
        // Check if already found
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
            if String(character) == centerLetter.lowercased() {
                containsCenterLetter = true
                break
            }
        }
        
        if containsCenterLetter == false {
            return "Missing center letter"
        }
        
        // Rule: Must only use letters from the hive
        for character in normalizedWord {
            var isFromHive = false
            for hiveLetter in hiveLetters {
                if String(character) == hiveLetter.lowercased() {
                    isFromHive = true
                    break
                }
            }
            if isFromHive == false {
                return "Not in word list" // Technically "Bad letter", but the game often says "Not in word list"
            }
        }
        
        // Rule: Must be in the possible words list
        var isValid = false
        for possible in allPossibleWords {
            if possible.lowercased() == normalizedWord {
                isValid = true
                break
            }
        }
        
        if isValid == false {
            return "Not in word list"
        }
        
        // If all checks pass, add the word and update score
        foundWords.append(normalizedWord)
        let wordScore = calculateScore(for: normalizedWord)
        score += wordScore
        
        if isPangram(word: normalizedWord) {
            return "Pangram!"
        }
        
        return "Nice!"
    }
    
    /// Calculates the score for a single valid word.
    /// - Parameter word: A valid word.
    /// - Returns: The points earned.
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
    /// - Parameter word: The word to check.
    /// - Returns: True if all 7 letters are present.
    func isPangram(word: String) -> Bool {
        let normalizedWord = word.lowercased()
        
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
    
    /// Calculates the maximum possible score for the current hive.
    /// - Returns: The total points of all possible words.
    func maximumPossibleScore() -> Int {
        var total = 0
        for word in allPossibleWords {
            total += calculateScore(for: word)
        }
        return total
    }
    
    /// Returns the player's rating based on their current score.
    /// - Returns: A string representing the rating.
    func currentRating() -> String {
        let maxScore = maximumPossibleScore()
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
}
