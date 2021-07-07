//
//  ContentView.swift
//  WordScramble
//
//  Created by Mehmet Atabey on 5.07.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var restarted = false
    
    //TODO: add a menu to choose difficulty.
    @State private var chosenDifficulty = 6
    
    
    @State private var score = 0
    
    var body: some View {
        VStack {
            HStack {
                HStack{
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.blue)
                    Button("Baştan başla") {
                        self.restartGame()
                    }
                }
                .padding(.leading, 10)
                Spacer()
                Text("Skor: \(score)")
                    .multilineTextAlignment(.center)
                    .padding(.trailing, 15)
                    .foregroundColor(.blue)
            }
            NavigationView {
                VStack {
                    TextField("Kelime girin:", text: $newWord, onCommit: addNewWord)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    List(usedWords, id: \.self) {
                        Image(systemName: "\($0.count).circle")
                        
                        Text($0)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
                .navigationBarTitle(rootWord)
                .onAppear(perform: {
                    initGame()
                })
                .alert(isPresented: $showingError) {
                    Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("Tamam")))
                }
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        guard isOriginal(word: answer) else {
            wordError(title: "Kelime daha önce kullanılmış", message: "Daha orijinal olman gerek")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Kelime verilen harflere uymuyor.", message: "Geçerli bir kelime girin.")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "\(answer) kurallara uymayan bir kelime", message: "Geçerli bir kelime girin.")
            return
        }
        
        self.score += answer.count
        usedWords.insert(answer, at: 0)
    }
    
    func initGame() {
        if let startWordsURL = Bundle.main.url(forResource: "\(chosenDifficulty) harfli kelimeler", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Can not load \(chosenDifficulty) harfli kelimeler.txt from Bundle")
    }
    
    func isOriginal(word: String) -> Bool {
        usedWords.filter({$0 == word}).first == nil
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
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        
        let range = NSRange(location: 0, length: word.utf16.count)
        
        let mispelledrange = checker.rangeOfMisspelledWord(
            in: word,
            range: range,
            startingAt: 0,
            wrap: false,
            language: "tr")
        
        //Day32 Challange
        
        if(word.count < 3) {
            return false
        }
        
        if(word == rootWord) {
            return false
        }
        
        return mispelledrange.location == NSNotFound
    }
    
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func restartGame() {
        usedWords.removeAll()
        self.score = 0
        self.newWord = ""
        self.initGame()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
