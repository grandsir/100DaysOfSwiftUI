//
//  ContentView.swift
//  Day 25 Challange- Rock Paper Scissors
//
//  Created by GrandSir on 20.02.2021.
//

import SwiftUI



struct ContentView: View {
    @State private var choices = ["Rock", "Paper", "Scissors"]
    
    let winnings = [
        "Rock": "Scissors",
        "Paper": "Rock",
        "Scissors": "Paper"
    ]
    
    @State private var winning = Bool.random()
    @State private var choice = Int.random(in: 0...2)
    @State private var win = false
    @State private var score = 0
    @State private var showingScore = false
    @State private var showingAlert = false
    @State private var correctAnswer = ""
    //@State private var tours = 0

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.red, .yellow]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack {
                Text("Choose to")
                    .font(.largeTitle)
                Spacer()
                Text(winning ? "Win": "Lose")
                    .bold()
                    .font(.largeTitle)
                Text("Against")
                    .bold()
                    .padding(.top, 25)
                    .font(.body)
                Text(choices[choice])
                    .fontWeight(.medium)
                    .padding(.top, 25)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .scaleEffect(1.8)
                Spacer()

                HStack {
                    ForEach(0..<3) {i in
                        Button(action: {
                            correctAnswer = winning ? winnings[winnings[choices[choice]]!]! : winnings[choices[choice]]!
                            win = winning ? winnings[winnings[choices[choice]]!]! == choices[i] : winnings[choices[choice]]! == choices[i]
                            choice = Int.random(in: 0...2)
                            winning = Bool.random()
                            showingAlert = true

                            if win {
                                score += 1
                            }
                            else {
                                score -= 1
                            }
                            //tours += 1
//                          Comments For challange.
//                            if tours == 10 {
//                                showingScore = true
//                            }
                        }, label: {
                            Text(choices[i])
                                .foregroundColor(.white)
                                .frame(width: 120, height: 50, alignment: .center)
                                .background(LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .leading, endPoint: .trailing))
                                .clipShape(Capsule())
                            
                        })
                    }
                }
                
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(win ? "Well done!" : "Uh oh"), message: Text(win ? "Your score is \(score)" : "Correct answer was \(correctAnswer)"), dismissButton: .default(Text("OK")))
            
//        .alert(isPresented: $showingScore) {
//            Alert(title: Text("Your Score is,"), message: Text(String(score)), dismissButton: .default(Text("Restart"))
//            {
//                self.resetGame()
//            }
//        )}

        }
        
        }
//    func resetGame () {
//        self.score = 0
//        self.tours = 0
//    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}