import Foundation
import Combine
import SwiftUI

class GameState: ObservableObject {
    @Published var board = [[Cell]]()
    @Published var turn: Tile = .cross
    @Published var noughtsScore = 0
    @Published var crossesScore = 0
    @Published var showAlert = false
    @Published var alertMessage = "Draw"

    init() {
        // mặc định X đi trước
        resetBoard(starting: .cross)
    }

    func turnText() -> String {
        return turn == .cross ? "Turn: X" : "Turn: O"
    }

    func placeTile(_ row: Int, _ column: Int) {
        guard row >= 0, row < board.count, column >= 0, column < board[row].count else { return }
        if board[row][column].tile != .empty { return }

        board[row][column].tile = (turn == .cross) ? .cross : .nought

        // kiểm tra thắng
        if checkForVictory() {
            if turn == .cross {
                crossesScore += 1
                alertMessage = "Crosses Win!"
            } else {
                noughtsScore += 1
                alertMessage = "Noughts Win!"
            }
            showAlert = true
            return
        }

        // nếu đầy -> xét bằng số X / O
        if isBoardFull() {
            let (crossCount, noughtCount) = countTiles()
            if crossCount > noughtCount {
                crossesScore += 1
                alertMessage = "Crosses Win by Count! (\(crossCount) vs \(noughtCount))"
            } else if noughtCount > crossCount {
                noughtsScore += 1
                alertMessage = "Noughts Win by Count! (\(noughtCount) vs \(crossCount))"
            } else {
                alertMessage = "Draw (\(crossCount) vs \(noughtCount))"
            }
            showAlert = true
            return
        }

        // chuyển lượt
        turn = (turn == .cross) ? .nought : .cross
    }

    private func isBoardFull() -> Bool {
        for row in board {
            for cell in row {
                if cell.tile == .empty { return false }
            }
        }
        return true
    }

    private func countTiles() -> (crosses: Int, noughts: Int) {
        var crosses = 0, noughts = 0
        for row in board {
            for cell in row {
                if cell.tile == .cross { crosses += 1 }
                else if cell.tile == .nought { noughts += 1 }
            }
        }
        return (crosses, noughts)
    }

    func checkForDraw() -> Bool {
        return isBoardFull() && !checkForVictory()
    }

    func checkForVictory() -> Bool {
        // vertical
        if isTurnTile(0,0) && isTurnTile(1,0) && isTurnTile(2,0) { return true }
        if isTurnTile(0,1) && isTurnTile(1,1) && isTurnTile(2,1) { return true }
        if isTurnTile(0,2) && isTurnTile(1,2) && isTurnTile(2,2) { return true }

        // horizontal
        if isTurnTile(0,0) && isTurnTile(0,1) && isTurnTile(0,2) { return true }
        if isTurnTile(1,0) && isTurnTile(1,1) && isTurnTile(1,2) { return true }
        if isTurnTile(2,0) && isTurnTile(2,1) && isTurnTile(2,2) { return true }

        // diagonal
        if isTurnTile(0,0) && isTurnTile(1,1) && isTurnTile(2,2) { return true }
        if isTurnTile(0,2) && isTurnTile(1,1) && isTurnTile(2,0) { return true }

        return false
    }

    func isTurnTile(_ row: Int, _ column: Int) -> Bool {
        guard row >= 0, row < board.count, column >= 0, column < board[row].count else { return false }
        return board[row][column].tile == turn
    }

    // resetBoard có thể nhận starter tuỳ chọn
    func resetBoard(starting: Tile? = nil) {
        var newBoard = [[Cell]]()
        for _ in 0...2 {
            var row = [Cell]()
            for _ in 0...2 {
                row.append(Cell(tile: .empty))
            }
            newBoard.append(row)
        }
        board = newBoard

        if let starter = starting {
            turn = starter
        } else {
            turn = Bool.random() ? .cross : .nought
        }
    }

    // reset score (nhận starter nếu muốn)
    func resetScore(starting: Tile? = nil) {
        crossesScore = 0
        noughtsScore = 0
        resetBoard(starting: starting)
    }
}

