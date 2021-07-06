//
//  ContentView.swift
//  UnitConvert
//
//  Created by Tao.T on 2021/7/6.
//

import SwiftUI

struct ContentView: View {
    
    //    1 吨= 1,000,000 克
    //    1 公斤 = 1,000 克
    //    1 毫克 = 0.001 克
    //    1 微克 = 0.000001克
    
    let massUnits = ["微克", "毫克", "克", "公斤", "吨"]
    @State private var inputUnitIndex = 2
    @State private var inputUnitNumber = ""
    @State private var outputUnitIndex = 2
    private var outputUnitNumber: Double {
        var inputCoefficient: Double = 0
        var outputCoefficient: Double = 0
        
        switch inputUnitIndex {
        case 0:
            inputCoefficient = 0.000001
        case 1:
            inputCoefficient = 0.001
        case 2:
            inputCoefficient = 1
        case 3:
            inputCoefficient = 1000
        case 4:
            inputCoefficient = 1000000
        default:
            inputCoefficient = 0
        }
        
        switch outputUnitIndex {
        case 0:
            outputCoefficient = 1000000
        case 1:
            outputCoefficient = 1000
        case 2:
            outputCoefficient = 1
        case 3:
            outputCoefficient = 0.001
        case 4:
            outputCoefficient = 0.000001
        default:
            outputCoefficient = 0
        }
        
        let gram = (Double(inputUnitNumber) ?? 0) * inputCoefficient * outputCoefficient
        
        return gram
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("输入要转换的质量")) {
                    TextField("test", text: $inputUnitNumber)
                        .keyboardType(.decimalPad)
                    Picker("输入的质量单位", selection: $inputUnitIndex) {
                        ForEach(0 ..< massUnits.count) {
                            Text("\(massUnits[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("转换后的质量")) {
                    Picker("输出的质量单位", selection: $outputUnitIndex) {
                        ForEach(0 ..< massUnits.count) {
                            Text("\(massUnits[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Text("\(outputUnitNumber)\(massUnits[outputUnitIndex])")
                }
                
                
            }
            .navigationTitle("单位转换")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
