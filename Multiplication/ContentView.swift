//
//  ContentView.swift
//  Multiplication
//
//  Created by Игорь Верхов on 13.08.2023.
//

import SwiftUI

struct Question: Hashable {
    let question: String
    let answer: Int
}

struct ContentView: View {
    
    @State private var currentTable = 2
    @State private var currentDifficulty = 1
    @State private var gameLaunching = false
    @State private var questionNumber = 0
    @State private var currentAnswer = ""
    @State private var score = 0
    @State private var showingGameOver = false
    
    @State private var variants = [Question]()
    var difficulty = ["5", "10", "15"]
    
    @State private var isPressed = 0.0
    
    var body: some View {
        VStack(alignment: .center) {
            if !gameLaunching {
                Spacer()
                List {
                    Section("What table are you training?") {
                        Picker("Choose", selection: $currentTable) {
                            ForEach(2..<10) {
                                Text("\($0)")
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.segmented)
                    }
                    Section("What difficulty are you chosing?") {
                        Picker("Difficulty", selection: $currentDifficulty) {
                            ForEach(1..<4, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.segmented)
                    }
                    
                }
                .transition(.scale)
                .frame(maxHeight: 250)
                .cornerRadius(30)
                .padding()
                
                Spacer()
                Button("Run") {
                    isPressed += 360
                    variants.removeAll()
                    generateVariants(table: currentTable, difficulty: currentDifficulty)
                    withAnimation() {
                        gameLaunching.toggle()
                    }
                }
                .frame(minWidth: 200, minHeight: 100)
                .background(.blue)
                .foregroundColor(.white)
                .font(.title)
                .clipShape(.capsule)
                .shadow(radius: 5)
                .rotation3DEffect(.degrees(isPressed), axis: (x: 0, y: 1, z: 0))
//                .animation(.default, value: isPressed)
                

            } else {
                Spacer()
                Text("Score: \(score)")
                    .font(.title)
                    .padding()
                Spacer()
                Text("\(variants[0].question)")
                    .font(.largeTitle)
                TextField("Answer", text: $currentAnswer)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .font(.title)
                Spacer()
                Button("Check") {
                    checkAnswer()
                }
                .frame(minWidth: 200, minHeight: 100)
                .background(.green)
                .foregroundColor(.white)
                .font(.title2)
                .clipShape(.capsule)
                .shadow(radius: 5)
                
                Button("Stop", role: .destructive) {
                    withAnimation {
                        gameLaunching.toggle()
                    }
                }
                .frame(minWidth: 100, minHeight: 50)
                .background(.red)
                .foregroundColor(.white)
                .font(.title2)
                .clipShape(.capsule)
                .shadow(radius: 5)
            }
        }
        .alert("Game over", isPresented: $showingGameOver) {
            Button("New game") {
                score = 0
                gameLaunching.toggle()
            }
        } message: {
            Text("You score: \(score)")
        }
    }
    
    func generateVariants(table: Int, difficulty: Int) {
        for _ in 1...difficulty * 5 {
            let currentQuestion = Int.random(in: 1...9)
            let currentAnswer = (table + 2) * currentQuestion
            variants.append(Question(question: "\(table + 2) X \(currentQuestion)", answer: currentAnswer))
        }
    }
    
    func checkAnswer() {
        if variants[0].answer == Int(currentAnswer) {
            score += 1
        }
        
        if variants.count == 1 {
            showingGameOver = true
        } else {
            variants.removeFirst()
        }
        currentAnswer = ""
    }
    
    
}

#Preview {
    ContentView()
}
