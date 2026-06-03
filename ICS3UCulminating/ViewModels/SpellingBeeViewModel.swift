import Foundation
import Observation

// MARK: - VIEW MODEL
// The View Model is the "brain" of the app.
// It manages the active game state and handles user interaction logic.
// We use the @Observable macro so the SwiftUI View knows when to refresh.
@Observable
class SpellingBeeViewModel {
    
    // MARK: - Stored properties (State)
    
    /// The specific puzzle data (letters and valid words) for this session.
    var puzzle: SpellingBeePuzzle
    
    /// The string of letters the user is currently typing.
    var currentWord: String = ""
    
    /// An array of words the player has already successfully submitted.
    var foundWords: [String] = []
    
    /// The player's current total score.
    var score: Int = 0
    
    /// A message to show the user, like "Nice!", "Pangram!", or "Too short".
    var message: String = ""
    
    // MARK: - Computed properties
    
    /// Derives the maximum possible score by summing up the value of every valid word.
    var maximumPossibleScore: Int {
        var total = 0
        for word in puzzle.validWords {
            total += calculateScore(for: word)
        }
        return total
    }
    
    /// Determines the player's rank based on what percentage of the total score they've earned.
    var currentRating: String {
        let maxScore = maximumPossibleScore
        if maxScore == 0 { return "Beginner" }
        
        // Calculate percentage (0.0 to 1.0)
        let percentage = Double(score) / Double(maxScore)
        
        // Return a name based on the percentage thresholds
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
    /// If no puzzle is provided, it picks a random one from our collection.
    init(puzzle: SpellingBeePuzzle? = nil) {
        if let providedPuzzle = puzzle {
            self.puzzle = providedPuzzle
        } else {
            // Pick a random puzzle from the list in SpellingBeePuzzle.swift
            // If the list is empty (shouldn't happen), we use a fallback
            self.puzzle = allPuzzles.randomElement() ?? allPuzzles[0]
        }
    }
    
    // MARK: - Functions (Intent)
    
    /// Resets the game state and picks a new random puzzle.
    func startNewGame() {
        // Pick a new random puzzle
        self.puzzle = allPuzzles.randomElement() ?? allPuzzles[0]
        
        // Reset all game state variables
        currentWord = ""
        foundWords = []
        score = 0
        message = "New Game Started!"
    }
    
    /// Adds a letter to the current typed word.
    func addLetter(_ letter: String) {
        currentWord += letter.lowercased()
        message = "" // Clear the old feedback message when the user starts typing again
    }
    
    /// Deletes the last character from the current word.
    func deleteLetter() {
        if currentWord.isEmpty == false {
            currentWord.removeLast()
        }
        message = ""
    }
    
    /// The main logic for when a user hits "Enter".
    func submitWord() {
        // Step 1: Check if the word is valid based on the game rules
        let result = validate(word: currentWord)
        
        // Step 2: If it's a "Success", update the score and the found words list
        if result == "Success" {
            foundWords.append(currentWord)
            
            // Calculate points for this word
            let wordScore = calculateScore(for: currentWord)
            score += wordScore
            
            // Provide special feedback if they found a Pangram (uses all letters)
            if isPangram(word: currentWord) {
                message = "Pangram!"
            } else {
                message = "Nice!"
            }
            
            // Clear the input field for the next word
            currentWord = ""
        } else {
            // Step 3: If validation failed, show the error message (e.g., "Too short")
            message = result
        }
    }
    
    /// Checks a word against all Spelling Bee rules.
    /// Returns "Success" if the word is valid, or an error message if it's not.
    func validate(word: String) -> String {
        let normalizedWord = word.lowercased()
        
        // RULE: Check if the word was already found
        for found in foundWords {
            if found == normalizedWord {
                return "Already found"
            }
        }
        
        // RULE: Words must be at least 4 letters long
        if normalizedWord.count < 4 {
            return "Too short"
        }
        
        // RULE: The word MUST include the center letter
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
        
        // RULE: The word must exist in the puzzle's valid word list
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
    
    /// Calculates how many points a word is worth.
    func calculateScore(for word: String) -> Int {
        var points = 0
        
        // Rule: 4-letter words are worth 1 point
        if word.count == 4 {
            points = 1
        } 
        // Rule: Words longer than 4 are worth 1 point per letter
        else if word.count > 4 {
            points = word.count
        }
        
        // Rule: If it's a pangram, add 7 bonus points
        if isPangram(word: word) {
            points += 7
        }
        
        return points
    }
    
    /// A helper function to check if a word uses every single letter from the hive.
    func isPangram(word: String) -> Bool {
        let normalizedWord = word.lowercased()
        let hiveLetters = puzzle.allLetters
        
        // Loop through every required letter in the puzzle
        for hiveLetter in hiveLetters {
            var letterFound = false
            
            // See if this hive letter appears anywhere in the typed word
            for character in normalizedWord {
                if String(character) == hiveLetter.lowercased() {
                    letterFound = true
                    break
                }
            }
            
            // If even ONE hive letter is missing, it's not a pangram
            if letterFound == false {
                return false
            }
        }
        
        // If the loop finished, every letter was found!
        return true
    }
}
