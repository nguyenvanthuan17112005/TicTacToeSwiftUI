import SwiftUI

struct ContentView: View {
    @StateObject var gameState = GameState()
    @State private var startingIsCross: Bool = true // true = X đi trước, false = O đi trước
    
    var body: some View {
        let borderSize: CGFloat = 5
        
        ZStack {
            Color.teal.opacity(0.3)
                .ignoresSafeArea()
            
            VStack {
                // Picker chọn ai đi trước (Segmented)
                HStack {
                    Text("First:")
                        .font(.headline)
                    Picker("", selection: $startingIsCross) {
                        Text("X").tag(true)
                        Text("O").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 120)
                    
                    // Nút bắt đầu ván mới với lựa chọn hiện tại
                    Button(action: {
                        let starter: Tile = startingIsCross ? .cross : .nought
                        gameState.resetBoard(starting: starter)
                    }) {
                        Text("New Round")
                            .font(.subheadline)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                Text(gameState.turnText())
                    .font(.title)
                    .bold()
                    .padding()
                
                Spacer()
                
                Text(String(format: "Crosses: %d", gameState.crossesScore))
                    .font(.title)
                    .bold()
                    .padding()
                
                VStack(spacing: borderSize) {
                    ForEach(0...2, id: \.self) { row in
                        HStack(spacing: borderSize) {
                            ForEach(0...2, id: \.self) { column in
                                // bảo vệ index để khỏi crash (thêm guard an toàn)
                                if row < gameState.board.count && column < gameState.board[row].count {
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
                                } else {
                                    // fallback an toàn (không xảy ra nếu board init đúng)
                                    Rectangle()
                                        .foregroundColor(.white)
                                        .aspectRatio(1, contentMode: .fit)
                                }
                            }
                        }
                    }
                }
                .padding(borderSize)
                .background(Color.black)
                .shadow(radius: 10)
                .padding()
                .alert(isPresented: $gameState.showAlert) {
                    Alert(
                        title: Text(gameState.alertMessage),
                        dismissButton: .default(Text("Okay")) {
                            // sau khi đóng alert, giữ người bắt đầu theo lựa chọn picker
                            let starter: Tile = startingIsCross ? .cross : .nought
                            gameState.resetBoard(starting: starter)
                        }
                    )
                }
                
                Text(String(format: "Nought: %d", gameState.noughtsScore))
                    .font(.title)
                    .bold()
                    .padding()
                
                Spacer()
                
                Button(action: {
                    // reset toàn bộ điểm và reset bàn với lựa chọn hiện tại
                    let starter: Tile = startingIsCross ? .cross : .nought
                    gameState.resetScore(starting: starter)
                }){
                    Text("Reset Scores")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    ContentView()
}

