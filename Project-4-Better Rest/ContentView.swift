//
//  ContentView.swift
//  BetterRest
//
//  Created by GrandSir on 20.02.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 0
    
    @State private var alertTitle = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                        VStack {
                        Text("   Your ideal bedtime is")
                            .font(.largeTitle)
                            .fontWeight(.light)
                            .foregroundColor(.red)
                        Spacer()
                        Text("   \(calculateBedTime())")
                }
                }
                Section { // Day 28 challange
                    Text("When do you want to wake up?")
                        .font(.headline)
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                }
                Section {
                    
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper(value: $sleepAmount, in: 4...12) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                Section {
                    Picker("Daily coffee in take", selection: $coffeeAmount) {
                        ForEach(1..<21) {coffee in
                            Text(coffee == 1 ? "1 cup" : "\(coffee) cups") // Day 28 challange
                        }
                    }
                }
            }
            .navigationTitle("Better Rest")
        }
    }
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    func calculateBedTime() -> String {
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60  * 60
        let minute = (components.minute ?? 0) * 60 * 60
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: Double(sleepAmount), coffee: Double(coffeeAmount + 1))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: sleepTime)
        }
        catch {
            return "something went wrong"
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
