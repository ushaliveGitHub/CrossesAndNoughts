//
//  Game.swift
//  UI Code Challenge
//
//  Created by Usha Natarajan on 8/20/21.
//  Copyright © 2021 SimpliSafe. All rights reserved.
//

import SwiftUI

struct GameView: View {
    @State var gameModel = GameModel()
    @State var gameOver: Bool = false
    
    func message()-> String{
        return (self.gameModel.gameOver.0 == .empty) ? self.gameModel.gameOver.0.rawValue : "\(self.gameModel.gameOver.0.rawValue) won 🎉"
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment:.center,spacing: 0) {
                Text("Noughts & Crosses")
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .padding(.top,5)
                Spacer()
                ForEach(0..<gameModel.squares.count / 3, content: { row in
                    HStack(spacing: 0){
                        ForEach(0..<3, content: { col in
                            
                            let index = row * 3  + col
                            
                            SquareView(square: gameModel.squares[index],
                                       proxy: proxy.size) {
                                _ = self.gameModel.draw(index: index, player: .user)
                                self.gameOver = self.gameModel.gameOver.1
                            }
                             DivLine(wide:3,length:proxy.size.height / 5, index:col)
                        })
                    }
                     DivLine(wide:proxy.size.height/2,length: 3,index: row)
                })
                Spacer()
            }.frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                .background(Color.white)
                .alert(isPresented: self.$gameOver, content: {
                    Alert(title: Text("Game Over"),
                          message: Text(message()),
                          dismissButton: Alert.Button.destructive(Text("Ok"), action: { self.gameModel.startOver() }
                                                                 ))
                })
        }
    }
}


struct DivLine : View {
    let wide: CGFloat
    let length: CGFloat
    @State var index: Int
    
    var body: some View {
        if index < 2 {
            Rectangle()
                .frame(width: wide, height: length)
                .background(Color.black)
        }else {
            EmptyView()
        }
    }
}

struct Game_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
