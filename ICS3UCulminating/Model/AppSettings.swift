import Foundation
import Observation

// MARK: - APP SETTINGS
// This class manages global preferences that need to be shared across the entire app.
// By using @Observable, any view that uses this object will automatically refresh
// when a property (like isDarkMode) changes.
@Observable
class AppSettings {
    
    // MARK: - Stored properties
    
    /// Global toggle for Dark Mode.
    var isDarkMode: Bool = false
    
    /// Global toggle for showing the word count in the game.
    var showWordCount: Bool = true
    
    /// Global toggle for Junior Mode (easier words).
    var juniorMode: Bool = false
    
    // MARK: - Initializer
    
    init() {}
}
