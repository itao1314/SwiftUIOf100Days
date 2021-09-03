//
//  ContentView.swift
//  BetterRest
//
//  Created by 陶涛 on 2021/8/5.
//

import SwiftUI

struct ContentView: View {
    
    static var defaultWakeTime: Date {
        var componets = DateComponents()
        componets.hour = 7
        componets.minute = 0
        return Calendar.current.date(from: componets) ?? Date()
    }
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    
    //    @State private var alertTitle = ""
    //    @State private var alertMessage = ""
    //    @State private var showingAlert = false
    
    var bedTime: String {
        do {
            let model = try SleepCalculator(configuration: .init())
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: sleepTime)
        } catch  {
            return "计算错误"
        }
    }
    
    //    func calculateBedtime() {
    //        do {
    //            let model = try SleepCalculator(configuration: .init())
    //            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
    //            let hour = (components.hour ?? 0) * 60 * 60
    //            let minute = (components.minute ?? 0) * 60
    //            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
    //            let sleepTime = wakeUp - prediction.actualSleep
    //            let formatter = DateFormatter()
    //            formatter.timeStyle = .short
    //            alertMessage = formatter.string(from: sleepTime)
    //            alertTitle = "你理想的睡眠开始时间是..."
    //        } catch  {
    //            alertTitle = "错误"
    //            alertMessage = "计算过程中出现错误"
    //        }
    //        showingAlert = true
    //    }
    
    var body: some View {
        NavigationView {
            
            Form {
                
                Section(header: Text("上床时间")) {
                    Text(bedTime)
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                }
                .font(.headline)
                
                Section(header: Text("你想什么时候起床")) {
                    
                    DatePicker("请选择时间", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                .font(.headline)
                
                Section(header: Text("睡眠时间")) {
                    Stepper(value: $sleepAmount, in: 4 ... 12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                .font(.headline)
                
                
                Section(header: Text("每天所需咖啡")
                ) {
                    //                    Stepper(value: $coffeeAmount, in: 1 ... 20) {
                    //                        if coffeeAmount == 1 {
                    //                            Text("1 cup");
                    //                        } else {
                    //                            Text("\(coffeeAmount) cups")
                    //                        }
                    //                    }
                    
                    Picker("Number of cups", selection: $coffeeAmount) {
                        ForEach(1 ..< 21) {
                            Text("\($0)")
                        }
                    }
                }
                .font(.headline)
            }
            .navigationBarTitle("BetterRest")
            //            .navigationBarItems(trailing:
            //                                    Button(action: calculateBedtime, label: { Text("Calculate") })
            //            )
            //            .alert(isPresented: $showingAlert, content: {
            //                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("好的")))
            //            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
