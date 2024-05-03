//
//  ContentView.swift
//  RockPaperScissor
//
//  Created by Galih Samudra on 26/02/24.
//

import SwiftUI

enum MoveResult {
    case win
    case lose
    case draw
}

enum Move {
    case paper, rock, scissor
    
    static func calculateMoveResult(playerMove: Move, enemyMove: Move) -> MoveResult {
        switch (playerMove, enemyMove) {
        case (.paper, .rock), (.scissor, .paper), (.rock, .scissor) :
            return .win
        case (.paper, .scissor), (.scissor, .rock), (.rock, .paper):
            return .lose
        default:
            return .draw
        }
    }
    
    func getImage() -> String {
        switch self {
        case .paper:
            return "📄"
        case .rock:
            return "🪨"
        case .scissor:
            return "✂️"
        }
    }
    
    func getName() -> String {
        switch self {
        case .paper:
            return "Paper"
        case .rock:
            return "Rock"
        case .scissor:
            return "Scissors"
        }
    }
}

struct ContentView: View {
    let listOfMoves: [Move] = [.paper, .rock, .scissor]
    @State private var enemyMoveIndex = Int.random(in: 0...2)
    @State private var winScore = 0
    @State private var loseScore = 0
    @State private var drawScore = 0
    @State private var buttonTitle = ""
    @State private var scoreTitle = ""
    @State private var showingScore = false
    private let MAX_QUESTION = 10
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.5), location: 0.7),
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.3), location: 0.7)
            ], center: .top, startRadius: 100, endRadius: 500)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Rock Paper Scissors")
                    .foregroundStyle(.white)
                    .font(.largeTitle.bold())
                
                VStack(spacing: 15) {
                    Text("Choose your move")
                        .foregroundStyle(.white)
                        .font(.largeTitle.bold())
                    
                    ForEach(0..<3) { number in
                        Button {
                            chooseMove(number)
                        } label: {
                            Text("\(listOfMoves[number].getImage()) \(listOfMoves[number].getName())")
                                .font(.title.bold())
                        }
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 50))
                Spacer()
                Spacer()
                VStack(spacing: 5) {
                    Text("WIN: \(winScore)")
                        .foregroundStyle(.white)
                        .font(.largeTitle.bold())
                    Text("LOSE: \(loseScore)")
                        .foregroundStyle(.white)
                        .font(.largeTitle.bold())
                    Text("DRAW: \(drawScore)")
                        .foregroundStyle(.white)
                        .font(.largeTitle.bold())
                }
                Spacer()
            }
            .padding()
        }.alert(scoreTitle, isPresented: $showingScore) {
            Button(buttonTitle) {
                nextRound()
            }
        } message: {
            Text("Currrent score is \(winScore) win, \(loseScore) lose, and \(drawScore) draw")
        }
    }
    
    private func chooseMove(_ number: Int) {
        let numberOfQuestion = 1 + winScore + loseScore + drawScore
        
        let playerMove = listOfMoves[number]
        enemyMoveIndex = Int.random(in: 0...2)
        let enemyMove = listOfMoves[enemyMoveIndex]
        let result = Move.calculateMoveResult(playerMove: playerMove, enemyMove: enemyMove)
        
        scoreTitle = "You choose \(playerMove.getName()) and your enemy choose \(enemyMove.getName()), "
        if numberOfQuestion == MAX_QUESTION {
            buttonTitle = "Play Again"
        } else {
            buttonTitle = "Continue"
        }
        switch result {
        case .win:
            scoreTitle += "You Win"
            winScore += 1
        case .lose:
            scoreTitle += "You Lose"
            loseScore += 1
        case .draw:
            scoreTitle += "It's a Draw"
            drawScore += 1
        }
        showingScore = true
    }
    private func nextRound() {
        let numberOfQuestion = 1 + winScore + loseScore + drawScore
        if numberOfQuestion == MAX_QUESTION {
            winScore = 0
            loseScore = 0
            drawScore = 0
        }
    }
}

#Preview {
    ContentView()
}
