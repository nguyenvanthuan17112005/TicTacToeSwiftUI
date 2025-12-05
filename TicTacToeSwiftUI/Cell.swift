import SwiftUI
import Foundation

enum Tile {
    case nought
    case cross
    case empty
}

struct Cell {
    var tile: Tile

    func displayTile() -> String {
        switch tile {
        case .nought: return "O"
        case .cross:  return "X"
        case .empty:  return ""
        }
    }

    func tileColor() -> Color {
        switch tile {
        case .nought: return .red
        case .cross:  return .black
        case .empty:  return .black
        }
    }
}

