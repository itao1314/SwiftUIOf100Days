//
//  ContentView.swift
//  ChallengeForDay25
//
//  Created by 陶涛 on 2021/8/5.
//

import SwiftUI

struct ContentView: View {
    
    @State var gameValues = ["Rock", "Paper", "Scissors"]
    @State var playerSelectedIndex  = 0
    var shouldWin: Bool {
      
        let computerIndex = Int.random(in: 0..<gameValues.count)
        
        
        if computerIndex > playerSelectedIndex {
            return true
        } else {
            return false
        }
        
    }
    
    var body: some View {
        VStack {
            Text("玩家 \(shouldWin ? "赢了": "输了")");
            Picker("选择您要出的", selection: $playerSelectedIndex) {
                ForEach(0 ..< gameValues.count) {
                    Text("\(gameValues[$0])")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
