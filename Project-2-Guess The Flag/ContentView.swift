//
//  ContentView.swift
//  Project-2 Guess The Flag
//
//  Created by GrandSir on 19.02.2021.
//

import SwiftUI

struct FlagImage: View {
    var image: String
    @Binding var color: Color
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule()
                        .foregroundColor(Color.black)
                        .opacity(0.35))
            .overlay(Capsule()
                        .stroke(color, lineWidth: 4))
            .shadow(color: color, radius: 10)
    }
}

struct ContentView: View {
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var tappedFlag = 0
    @State private var score = 0 {
         didSet {
            if score < 0 {
                score = 0
            }
        }
    }
    @State private var animationAmount = 0.0
    @State private var fadeAmount = 1.0
    @State private var color = Color.red
    
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: 30){
                VStack {
                    Text("Tap the flag of!")
                        .foregroundColor(.white)
                        .scaleEffect(1.4)
                    Text(countries[correctAnswer])
                        
                        .foregroundColor(color)
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .padding()
                        .scaleEffect(1.2)
                        .shadow(color: color, radius: 5)

                }
                Spacer()
                ForEach(0 ..< 3) {number in
                    Button(action: {
                        self.fadeAmount = 1.0
                        self.flagTapped(number)
                        self.tappedFlag = number
                        withAnimation(Animation.easeInOut(duration: 0.5)) {
                            self.animationAmount += 360
                        }
                        self.fadeAmount = 0.25
                        
                        if tappedFlag != correctAnswer {
                            self.color = .gray
                        }

                    }) {
                        FlagImage(image: self.countries[number], color: $color)
                            .opacity(tappedFlag == number ? 1 : fadeAmount)
                            .rotation3DEffect(
                                .degrees(correctAnswer == tappedFlag && correctAnswer == number ? animationAmount : 0.0),
                                axis: (x: 0.0, y: 1.0, z: 0.0)
                            )
                    }
                    .accessibility(label: Text( self.labels[self.countries[correctAnswer], default: "Unknown Flag"]))
                }
                Spacer()
                Spacer()
                Text("Your Score is: \(score)")
                    .font(.headline)
                    .font(.system(size: 30))
                    .foregroundColor(color)
                    .shadow(color: color, radius:  5)
                    .padding()
            }
        }.alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(scoreTitle == "Wrong!" ? "Oops, this is the flag of \(self.countries[tappedFlag])": "Your score is now \(score)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
                self.fadeAmount = 1
                self.color = .red
            }
            )}
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer{
            self.scoreTitle = "Well done!"
            self.score += 1
        }
        else {
            self.scoreTitle = "Wrong!"
            self.score -= 3
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
