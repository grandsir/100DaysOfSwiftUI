//
//  ContentView.swift
//  Project-2 Guess The Flag
//
//  Created by GrandSir on 19.02.2021.
//

import SwiftUI

struct FlagImage: View {
    var image: String
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule()
                        .foregroundColor(Color.black)
                        .opacity(0.35))
            .overlay(Capsule()
                        .stroke(Color.red, lineWidth: 4))
            .shadow(color: .red, radius: 10)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var tappedFlag = 0
    @State private var score = 0
    
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: 30){
                VStack {
                    Text("Tap the flag of!")
                        .foregroundColor(.white)
                        .scaleEffect(1.4)
                    Text(countries[correctAnswer])
                        
                        .foregroundColor(.red)
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .padding()
                        .scaleEffect(1.2)
                        .shadow(color: .red, radius: 5)

                }
                Spacer()
                ForEach(0 ..< 3) {number in
                    Button(action: {
                        self.flagTapped(number)
                        self.tappedFlag = number
                        print(correctAnswer)
                        print(number)
                        print(self.countries[number])
                        print(self.countries)
                    }) {
                        FlagImage(image: self.countries[number]) // Day 24 Challange
                    }
                }
                Spacer()
                Spacer()
            }
        }.alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: scoreTitle == "Wrong!" ? Text("Wrong! that's the flag of \(countries[tappedFlag])"): Text("Your score is \(score)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            }
            )}
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer{
            scoreTitle = "Correct"
            score += 1
        }
        else {
            scoreTitle = "Wrong!"
        }
        showingScore = true
    }
    
    func askQuestion () {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().colorScheme(.dark)
    }
}
