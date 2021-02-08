//
//  HangmanState.swift
//  Hangman
//
//  Created by Lauren Go on 2020/09/29.
//

import Foundation

class HangmanViewModel : ObservableObject {
    
    @Published var numIncorrect: Int! // number of incorrect guesses
    @Published var incorrectGuesses: [Character]! // character array of incorrectly guessed letters
    @Published var guessString: String! // user's progress on guessing the correct word
    @Published var gameStatus: Bool! // boolean of whether game isover
    @Published var theme: String = "Native American" // theme of phrases
    
    var correctPhrase: String! // the correct word the user is trying to guess
    var phrases: [String] = [String]() // phrases based on theme
    
    /* Initializes a new game. */
    init() {
        restart()
    }
    
    /* Resets model properties to restart game. */
    func restart() {
        
        // initial state of variables
        self.numIncorrect = 0
        self.incorrectGuesses = [Character]()
        self.gameStatus = false
        
        self.phrases = pickThemePhrases() // sets possible phrases based on theme
        self.correctPhrase = phrases.randomElement()! // picks random phrase from phrases
        
        // initial state of user guesses is all "-"
        self.guessString = ""
        correctPhrase.forEach { c in
            if (c == " ") {
                self.guessString += " "
            } else {
                self.guessString += "-"
            }
        }
    }
    
    /* Sets theme and restarts game. */
    func pickTheme(theme: String) {
        
        if (theme == "Native American") {
            self.theme = "Native American"
        } else if (theme == "Thanksgiving") {
            self.theme = "Thanksgiving"
        } else {
            self.theme = "Christmas"
        }
        
        restart()
    }
    
    /* Returns an array of phrases based on theme. */
    func pickThemePhrases() -> [String] {
        if (self.theme == "Native American") {
            return ["mayflower", "plymouth", "arrowhead", "buffalo", "wildlife", "pilgrims", "bone", "canoe", "ceremony", "fur", "harvest", "ritual", "spear", "apache", "comanche", "cherokee", "crow", "navajo", "pueblo", "sioux"]
        } else if (self.theme == "Thanksgiving") {
            return ["turkey", "stuffing", "corn", "grateful", "feast", "america", "autumn", "celebrate", "fall", "gobble", "gravy", "harvest", "ham", "leaf", "november", "pie", "squash", "thankful", "tradition", "yam"]
        } else {
            return ["rudolph", "blitzen", "comet", "cupid", "dasher", "dancer", "prancer", "angel", "bell", "chimney", "december", "frosty", "snowman", "icicle", "miracle", "merry", "noel", "grinch", "scrooge", "tinsel", "star", "toys", "yuletide"]
        }
    }
    
    /*
     Checks if the game has reached a lose state.
     - Returns: A Boolean for if the user won or not and has guesses left.
     */
    public func didLose() -> Bool {
        // if the number of incorrect guesses exceeds 5, the user loses
        if (numIncorrect >= 6) {
            return true
        }
        return false
    }
    
    /*
     Checks if the game has reached a win state.
     - Returns: A Boolean for if the user won or not and has guesses left.
     */
    public func didWin() -> Bool {
        // if the number of incorrect guesses is less than 5 and the user correctly guesses all letters, the user wins
        if (!guessString.contains("-") && numIncorrect <= 6) {
            return true
        }
        return false
    }
    
    /*
     Processes the user's guess.
     - Parameter guess letter: Character for the letter that is being guessed.
     */
    func makeGuess(guess letter: Character) {
        // TODO: Update variables and parameters to reflect the user's input.
        // 1. Check that the user has not already guessed the letter.
        // 2. If the phrase contains the guessed letter, update the progress string to show that letter.
        // 3. If the phrase does not contain the guessed letter, add the letter to the incorrect guesses array and iterate the incorrect guesses count.
        
        // makes the guess lowercased
        let lcLetter = Character(letter.lowercased())
        
        // checks if the game is already over
        if (didLose() || didWin()) {
            return
        }
        
        if (incorrectGuesses.contains(lcLetter) || guessString.contains(lcLetter)) { // if the letter has already been guessed, do nothing
            return
        } else {
            if (correctPhrase.contains(lcLetter)) { // if the guess is correct, fill in slot in the guess string
                let charCorrectPhrase = Array(correctPhrase) // creates a character array of the correct phrase
                let swapped = charCorrectPhrase.map { (c : Character) -> Character in
                    if (c == lcLetter) {
                        return lcLetter
                    } else if guessString.contains(c) {
                        return c
                    } else {
                        return "-"
                    }
                }
                guessString = String(swapped)
            } else { // if guess is wrong, add to the incorrect guesses
                incorrectGuesses.append(lcLetter)
                numIncorrect += 1
            }
        }
        
        // checks if game is over
        if (didWin() || didLose()) {
            gameStatus = true
        }
        
    }
    
    /*
     Returns a message to notify the winner if they won or not
     - Returns: Message depending on whether they won or not
     */
    public func getFinalMessage() -> String {

        if didWin() {
            return "Congratulations! You win!"
        }
        if didLose() {
            return "You lose :("
        }
        return ""
    }
}
