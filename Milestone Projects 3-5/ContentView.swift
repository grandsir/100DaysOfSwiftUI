//
//  ContentView.swift
//  Day 33 Challange
//
//  Created by Mehmet Atabey on 9.07.2021.
//

import SwiftUI

let difficulties = ["😜 Very Easy", "😄 Easy", "😐 Normal", "🙄 Hard", "😳 Very Hard"]
let colors = [Color.purple, .red, .pink, .yellow, .blue, .orange, .green, .gray, .black]

func createNewMultiplication(chosenDifficulty: String, times: Int) -> Array<String> {
    
    let chosenIndex = difficulties.firstIndex(of: chosenDifficulty) ?? 0
    
    
    var array = Array<String>()
    
    
    func appendRandomNumToArray(in range:Range<Int>) {
        for _ in 0..<times {
            array.append(String(Int.random(in: range)))
        }
    }
    
    
    
    switch chosenIndex {
    case 0:
        appendRandomNumToArray(in: 1..<4)
        
    case 1:
        appendRandomNumToArray(in: 2..<6)
        
    case 2:
        appendRandomNumToArray(in: 3..<7)
        
    case 3:
        appendRandomNumToArray(in: 4..<9)
        
    case 4:
        appendRandomNumToArray(in: 5..<12)
        
        
    default:
        for _ in 0..<2 {
            array.append(String(Int.random(in: 0..<1)))
        }
    }
    return array
    
}



struct ContentView: View {
    @State private var chosenDifficulty = ""
    @State private var multiplicationIndex = 2
    @State private var showingSettings = true
    @State private var value = ""
    
    @State private var isShowing = false
    @State private var answer = false
    
    @State private var opacity = 1.0
    
    
    let numbers: [Int] = Array(2...4)
    var body: some View {
        NavigationView {
            VStack {
                Group {
                    if showingSettings {
                        List {
                            Picker("Choose Difficulty", selection: $chosenDifficulty) {
                                ForEach(difficulties, id: \.self) {
                                    Text($0)
                                }
                            }
                            
                            Section(header: Text("Choose multiplication times").textCase(nil)) {
                                Picker("", selection: $multiplicationIndex) {
                                    ForEach(numbers, id:\.self){
                                        Text("\($0)")
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                
                            }
                        }
                        .navigationBarTitle("Difficulty:\(chosenDifficulty)")
                        Button("Start Game") {
                            self.showingSettings = false
                        }
                    }
                    else {
                        ZStack {
                            Text(answer ? "WELL DONE!👍" : "Uh, oh this isn't correct answer")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .opacity(isShowing ? Double(2.5 - self.opacity) : 0)
                                .animation(.easeInOut(duration: 1))
                        }
                        
                        VStack {
                            let string = createNewMultiplication(chosenDifficulty: chosenDifficulty, times: multiplicationIndex)
                            Spacer()
                            Spacer()
                            HStack {
                                ForEach(0..<string.count) {index in
                                    if index != 0 {
                                        Text("x")
                                            .font(.system(size: 60))
                                            .foregroundColor(colors.randomElement())
                                            .bold()
                                    }
                                    
                                    Text(string[index])
                                        .font(.system(size: 60))
                                        .foregroundColor(colors.randomElement())
                                        .bold()
                                }
                            }
                            
                            Spacer()
                            Spacer()
                            TextField("Enter your answer", text: $value)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .border(Color.blue)
                                .keyboardType(.numberPad)
                            Spacer()
                            Button(action: {
                                if !isShowing {
                                    var result = 1
                                    for number in string {
                                        result *= Int(number)!
                                    }
                                    self.opacity = 2
                                    isShowing = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        isShowing = false
                                        self.opacity = 1
                                    }
                                    
                                    if result == Int(value) {
                                        answer = true
                                    }
                                    
                                    else {
                                        answer = false
                                    }
                                }
                                
                                
                                
                            }) {
                                Text("Submit!")
                                    .font(.largeTitle)
                            }
                            Spacer()
                            
                        }
                        .opacity(Double(2-self.opacity))
                        .navigationBarTitle("Multiplication Time!")
                        .navigationBarItems(leading:
                                                Button(action: {
                                                    showingSettings = true
                                                    value = ""
                                                }, label: {
                                                    HStack {
                                                        Image(systemName: "arrowshape.turn.up.left")
                                                        Text("Return to settings")
                                                    }
                                                })
                        )
                        
                    }
                    
                }
                
                Spacer()
            }
            }
            
        .onAppear{
            chosenDifficulty = difficulties[0]
        }
        
    }
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
