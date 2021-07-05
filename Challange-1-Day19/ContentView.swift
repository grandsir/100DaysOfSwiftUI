//
//  ContentView.swift
//  Day-19-Challange
//
//  Created by GrandSir on 18.02.2021.
//

import SwiftUI

func calculateSecond(value : Int, source: String, target: String) -> Double{
    let dict = [
        "second" : 1,
        "minute": 60,
        "hour": 3600,
        "day": 86_400,
        "week": 604_800,
        "month": 2_629_743.83,
        "year": 31_556_926,
        "century": 3_155_692_600,
        "Average human life": 2_208_984_820]

    return Double(value) * dict[source]! / dict[target]!
}

struct ContentView: View {
    @State private var time = 0
    @State private var selectedTime = 0
    var amount = 0
    let timeUnits = ["second", "minute", "hour", "day", "week",  "year", "century", "Average human life"]
    @State private var timeValue = ""
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                TextField("Enter the value", text: $timeValue)
                    .keyboardType(.numberPad)
                }
                Section {
                    Picker("From", selection: $time) {
                        ForEach(0..<timeUnits.count) {
                            Text(timeUnits[$0])

                        }
                    }
                }
                Section {
                    Picker("To", selection: $selectedTime) {
                        ForEach(0..<timeUnits.count) {
                            Text(timeUnits[$0])
                        }
                    }
                }
                Section{
                    Text("\(timeValue == "" ? "0": timeValue) \(timeUnits[time]) = \(calculateSecond(value: Int(timeValue) ?? 0, source: timeUnits[time], target: timeUnits[selectedTime]), specifier: "%.2f") \(timeUnits[selectedTime])")
                }
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
