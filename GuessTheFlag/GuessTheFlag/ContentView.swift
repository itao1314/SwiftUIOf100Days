//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by 陶涛 on 2021/7/13.
//

import SwiftUI

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0 ... 2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var currentScore = 0
    
    @State private var animationAmounts = [0.0, 0.0, 0.0]
    @State private var opacities = [1.0, 1.0, 1.0]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        flagTapped(number)
                    }, label: {
                        Image(self.countries[number].lowercased())
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .black, radius: 2)
                    })
                    .rotation3DEffect(
                        .degrees(animationAmounts[number]),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                    .opacity(opacities[number])
                    
                }
                Text("您的得分是\(currentScore)")
                    .foregroundColor(.white)
                Spacer()
            }
            
        }
        .alert(isPresented: $showingScore, content: {
            Alert(title: Text(scoreTitle), message: Text("\(scoreTitle)! That’s the flag of \(countries[correctAnswer])"), dismissButton: .default(Text("Continue")))
        })
    }
    
    func flagTapped(_ number: Int) {
        
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            currentScore += 1
            withAnimation {
                animationAmounts[number] += 360
                for (index, _) in opacities.enumerated() {
                    if index != number {
                        opacities[index] = 0.25
                    }
                }
            }
        } else {
            scoreTitle = "Wrong"
            currentScore -= 1
        }
        
        
        
//        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0 ... 2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
