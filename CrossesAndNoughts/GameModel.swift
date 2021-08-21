//
//  GameModel.swift
//  UI Code Challenge
//
//  Created by Usha Natarajan on 8/20/21.
//  Copyright © 2021 SimpliSafe. All rights reserved.
//

import Foundation
import SwiftUI

enum Status: String{
    case empty = "Draw"
    case user = "You"
    case guest = "Guest"
    
    var symbol: String {
        switch self {
            case .empty : return ""
            case .user: return "X"
            case .guest: return "O"
        }
    }
    
    var paint: Color {
        switch self {
            case .empty : return .clear
            case .user: return .red
            case .guest: return .blue
        }
    }
}

class GameModel: ObservableObject {
    @Published var squares = [Square]()
    
    init() {
        for _ in 0...8 {
            squares.append(Square(status: .empty))
        }
    }
    
    var gameOver: (Status, Bool){
        get {
            if getWinner != .empty { //game over exit
                return(getWinner,true)
            }else{//continue with the game
                if squares.contains(where: { $0.status == .empty}) {
                    return (.empty,false)
                }
                return (.empty,true)
            }
        }
    }

    func startOver() {
        squares.removeAll()
        for _ in 0...8 {
            squares.append(Square(status: .empty))
        }
    }
    
    private func checkRows(_ matrix: [[Square]])->Status? {
        for i in 0...2 {
            if let winner = allMatch(matrix[i]), winner != .empty {
                return winner
            }
        }
        return nil
    }
    
    private func allMatch(_ list: [Square])->Status? {
        if (list.filter{$0.status == list.first?.status}.count == list.count) {
            return list.first?.status
        }else{
            return nil
        }
    }
    
    private func transpose(_ matrix: [[Square]]) -> [[Square]] {
        var transposed:[[Square]] = []
        for index in 0..<matrix.first!.count {
            transposed.append(matrix.map{$0[index]})
        }
        return transposed
    }
    
    
    var getWinner: Status {
        // Convert list to a matrix
        var iteration = squares.makeIterator()
        let twoDimension = [[0,0,0],[0,0,0],[0,0,0]]
        var matrix = twoDimension.map { $0.compactMap { _ in iteration.next()}}
        
         //check if  rows have a match
        if let winner = checkRows(matrix)  { return winner }
        
        // check if diagonals match
        if let winner = allMatch([matrix[0][0],matrix[1][1],matrix[2][2]]), winner != .empty { return winner}
        if let winner = allMatch([matrix[2][0],matrix[1][1],matrix[0][2]]), winner != .empty { return winner}
        
        // Transpose the columns to rows and check for winner
        matrix = self.transpose(matrix)
        if let winner = checkRows(matrix)  { return winner }
        return Status.empty
    }
    
    func drawGuest(){
        var index = Int.random(in: 0...8)
        while draw(index: index, player: .guest) == false && gameOver.1 == false {
            index = Int.random(in: 0...8)
        }
    }
    
    func draw(index: Int, player: Status) -> Bool {
        if squares[index].status == .empty {
            squares[index].status = player
            if player == .user {
                drawGuest()
            }
            return true
        }
        return false
    }
}

class Square: ObservableObject {
    @Published var  status: Status
    
    init(status: Status) {
        self.status = status
    }
}
