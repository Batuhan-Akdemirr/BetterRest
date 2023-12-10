//
//  ContentView.swift
//  BetterRest
//
//  Created by Batuhan Akdemir on 10.12.2023.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    let config = MLModelConfiguration()
    
    var calculateBedTime : String  {
        
        do {
           
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Int64(hour + minute), estimatedSleep: sleepAmount, coffee: Int64(coffeeAmount) )
            
            let sleepTime = wakeUp - prediction.actualSleep
            
          
         return sleepTime.formatted(date: .omitted, time: .shortened)
            
            
        } catch {
          return "Upppsss there was an error"
        }
        
        
    }
    
   static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? .now
    }
    
    
    var body: some View {
  
        NavigationStack {
            

            Form {
                Section("When do you want to wake up ?") {
                    DatePicker("Please enter a time ", selection: $wakeUp , displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section("Desired amount of sleep") {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount , in: 4...12, step: 0.25)
                }
                
                
                Section("Daily coffe intake") {
                        Picker("^[\(coffeeAmount) cup](inflect: true)", selection: $coffeeAmount) {
                             ForEach(1...20, id:\.self) {
                                        Text("\($0)")
                        }
                    }
                        .pickerStyle(.navigationLink)
                }
                
                
                Section("Your ideal bedtime"){
                    Text(calculateBedTime)
                }
                
           
            }
           
            .navigationTitle("BetterRest")
            .preferredColorScheme(.dark)
            
            
           // .introspectTableView( $0.backgroundColor = .systemBlue )
            //.scrollContentBackground(.hidden)
           // .background(.yellow)
          
        
        }
    }
}

/*
 #Preview {
 ContentView()
 }
 
 */
