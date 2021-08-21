//
//  File.swift
//  CrossesAndNoughts
//
//  Created by Usha Natarajan on 8/20/21.
//

import SwiftUI

struct SquareView: View {
    @ObservedObject var square: Square
    @State var proxy: CGSize
    var action: ()->Void
    
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Text(self.square.status.symbol)
                .font(Font.custom("Chalkduster", size: proxy.width / 10))
                .bold()
                .frame(width:proxy.width / 4, height: proxy.width / 4, alignment: .center)
                .foregroundColor(square.status.paint)
                .background(Color.gray.opacity(0.02)).cornerRadius(10)
                .padding(4)
        }
    }
}
