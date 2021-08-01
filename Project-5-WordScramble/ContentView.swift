//
//  ContentView.swift
//  Project-5-WordScramble
//
//  Created by GrandSir on 22.02.2021.
//

import SwiftUI

struct ContentView: View {
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.red)]
    }
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var score = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: startGame) {
                Text("Restart")
            }
            .padding(.leading, 30)
            
            NavigationView {
                VStack {
                    Spacer()
                    TextField("Enter your word", text:  $newWord, onCommit: addNewWord)
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Form {
                        Section(
                            header: HStack {
                                Text("Used Words")
                                Spacer()
                                Text("Current Score: \(score)")
                            }
                            .font(.headline)
                            .padding()
                        )
                        {
                            List(usedWords, id: \.self) {word in
                                HStack {
                                    Text(word)
                                    Spacer()
                                    Image(systemName: "\(word.count).circle")
                                        .imageScale(.large)
                                }
                                .accessibilityElement(children: .ignore)
                                .accessibility(label: Text("\(word), \(word.count) letters"))
                            }
                        }
                        .textCase(nil)
                    }
                }
                .navigationTitle(rootWord)
                .onAppear(perform: startGame)
                .alert(isPresented: $showingError) {
                    Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
    func addNewWord () {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard isRealWord(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word")
            return
        }
        guard isSame(word: answer) else {
            wordError(title: "Same word as root word.", message: "Be much more original.")
            return
        }
        guard isReal(word: answer) else {
            wordError(title: "Too short", message: "You have to enter words longer than 3 letters.")
            return
        }
        usedWords.insert(answer, at: 0)
        score += answer.count
        newWord = ""
    }
    
    func startGame() {
        self.score = 0
        self.usedWords.removeAll()
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsUrl) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord.lowercased()
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            }
            else {
                return false
            }
        }
        
        return true
    }
    func isRealWord(word: String) -> Bool  {
        let checker = UITextChecker()
        let range = NSRange(location:0, length: word.utf16.count)
        let mispelledWord = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return mispelledWord.location == NSNotFound
    }
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    func isSame(word: String) -> Bool {
        return word.lowercased() != rootWord
    }
    
    func isReal(word: String) -> Bool {
        return word.count >= 3
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
