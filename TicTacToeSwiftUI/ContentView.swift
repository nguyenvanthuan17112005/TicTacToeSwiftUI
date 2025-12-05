//
//  ContentView.swift
//  TicTacToeSwiftUI
//
//  Created by Nguyễn Văn Thuận on 5/12/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var gameState = GameState()
    
    var body: some View {
        let borderSize: CGFloat = 5
        
        // 1. Dùng ZStack để xếp chồng màu nền xuống dưới cùng
        ZStack {
            
            // --- MÀU NỀN CHO APP ---
            // Bạn có thể đổi .teal thành màu khác (.blue, .gray,...) hoặc LinearGradient
            Color.teal.opacity(0.3) // Màu xanh ngọc nhẹ
                .ignoresSafeArea()  // Tràn lên tai thỏ và xuống dưới
            
            // Nội dung chính của game nằm đè lên trên
            VStack {
                Text(gameState.turnText())
                    .font(.title)
                    .bold()
                    .padding()
                
                Spacer()
                
                Text(String(format: "Crosses: %d", gameState.crossesScore))
                    .font(.title)
                    .bold()
                    .padding()
                
                // --- BÀN CỜ ---
                VStack(spacing: borderSize) {
                    ForEach(0...2, id: \.self) { row in
                        HStack(spacing: borderSize) {
                            ForEach(0...2, id: \.self) { column in
                                let cell = gameState.board[row][column]
                                Text(cell.displayTile())
                                    .font(.system(size: 60))
                                    .foregroundColor(cell.tileColor())
                                    .bold()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .aspectRatio(1, contentMode: .fit)
                                    .background(Color.white)
                                    .onTapGesture {
                                        gameState.placeTile(row, column)
                                    }
                            }
                        }
                    }
                }
                // 2. TẠO VIỀN CHO TRÒ CHƠI
                // Thêm padding bằng đúng độ dày viền (5), sau đó tô nền đen
                // Lớp nền đen này sẽ hiện ra ở các khe hở (spacing) VÀ phần padding vừa thêm
                .padding(borderSize)
                .background(Color.black)
                // (Tuỳ chọn) Thêm bóng đổ cho bàn cờ nổi lên
                .shadow(radius: 10)
                .padding() // Padding bên ngoài để bàn cờ không dính sát mép màn hình
                
                .alert(isPresented: $gameState.showAlert) {
                    Alert(
                        title: Text(gameState.alertMessage),
                        dismissButton: .default(Text("Okay")) {
                            gameState.resetBoard()
                        }
                    )
                }
                
                Text(String(format: "Nought: %d", gameState.noughtsScore))
                    .font(.title)
                    .bold()
                    .padding()
                
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
