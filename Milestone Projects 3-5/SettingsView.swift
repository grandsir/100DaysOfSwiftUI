//
//  SettingsView.swift
//  Day 33 Challange
//
//  Created by Mehmet Atabey on 10.07.2021.
//

import SwiftUI

struct SettingsView : View {
    var body: some View {
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
                .navigationBarTitle("Difficulty: \(chosenDifficulty)")
            }
            
        }
    }
    
}
