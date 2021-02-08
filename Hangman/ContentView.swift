//
//  ContentView.swift
//  Hangman
//
//  Created by Lauren Go on 2020/09/29.
//

import SwiftUI

struct ContentView: View {
    
    // an ObservedObject for the HangmanViewModel
    @ObservedObject var viewModel: HangmanViewModel = HangmanViewModel()
    
    // 2D array of button values for user inputs and keyboard
    let buttonValues: [[Character]] = [
        ["A", "B", "C", "D", "E", "F", "G"],
        ["H", "I", "J", "K", "L", "M", "N"],
        ["O", "P", "Q", "R", "S", "T", "U"],
        ["V", "W", "X", "Y", "Z"]
    ]
    
    var body: some View {
        VStack {
            
            // top bar
            HStack{
                // a menu to select a theme for the guess words
                Menu("Theme: \(viewModel.theme)") {
                    Button("Native American", action: {viewModel.pickTheme(theme: "Native American")})
                    Button("Thanksgiving", action: {viewModel.pickTheme(theme: "Thanksgiving")})
                    Button("Christmas", action: {viewModel.pickTheme(theme: "Christmas")})
                }
                .font(.system(size: UIScreen.main.bounds.height * 0.025))
                .foregroundColor(Color(#colorLiteral(red: 0.9326148629, green: 0.724404335, blue: 0.7727141976, alpha: 1)))
                
                Spacer()
                
                // restart button to start new game
                Button(action: {viewModel.restart()}) {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Restart")
                }
                .padding(12)
                .font(.system(size: UIScreen.main.bounds.height * 0.025))
                .background(Color(#colorLiteral(red: 0.9326148629, green: 0.724404335, blue: 0.7727141976, alpha: 1)))
                .foregroundColor(Color.white)
                .cornerRadius(20)
            }
            .padding()
            
            // image based on number of incorrect guesses
            Image("hangman" + String(viewModel.numIncorrect))
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 0.6)
            
            
            Spacer()
            
            // displays user's progress on guesses so far
            Text(viewModel.guessString)
                .font(.system(size: UIScreen.main.bounds.height * 0.1))
                .foregroundColor(Color(#colorLiteral(red: 0.6979997754, green: 0.6980653405, blue: 0.6979561448, alpha: 1)))
                .padding()
            
            // displays user's incorrect guesses thus far
            HStack {
                Text("Incorrect Guesses:")
                    .font(.system(size: UIScreen.main.bounds.height * 0.025))
                ForEach(viewModel.incorrectGuesses, id:\.self) { guess in
                    Text(String(guess))
                        .font(.system(size: UIScreen.main.bounds.height * 0.025))
                        .foregroundColor(Color(#colorLiteral(red: 0.6979997754, green: 0.6980653405, blue: 0.6979561448, alpha: 1)))
                }
                Spacer()
            }
            .padding()
            
            // creates keyboard
            VStack {
                ForEach(buttonValues, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { button in
                            KeyboardButtonView(viewModel: viewModel, button: button)
                        }
                    }
                }
                .padding(10)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom)
        .alert(isPresented: $viewModel.gameStatus) {
            Alert(title: Text(viewModel.getFinalMessage()), message: Text("Please start new game!"), dismissButton: .default(Text("Ok")))
        } // alert when game is over
    }
}

// creates view for each button in keyboard
struct KeyboardButtonView: View {
    
    @ObservedObject var viewModel: HangmanViewModel
    var button: Character
    
    var body: some View {
        
        Button(action: {
            viewModel.makeGuess(guess: button)
        }, label: {
            Text(String(button))
                .font(.title)
                .foregroundColor(Color.white)
        })
        .frame(width: self.buttonWidth(button: button), height: self.buttonHeight())
        .background(Color(#colorLiteral(red: 0.7890181541, green: 0.8936513066, blue: 0.8786723018, alpha: 1)))
        .cornerRadius(10)
        
    }
    // sets width of button
    func buttonWidth(button: Character) -> CGFloat {
        if (button == "V" || button == "W" || button == "X" || button == "Y" || button == "Z" ) {
            return (UIScreen.main.bounds.width - 4 * 10) / 6
        }
        return (UIScreen.main.bounds.width - 5 * 10) / 8
    }
     
    // sets height of button
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.height - 5) * 0.035
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
