//
//  AIGameState.swift
//  XO-game
//
//  Created by Denis Kuzmin on 24.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class AIGameState: PlayGameState {
 
    var isMoveCompleted: Bool = false
 
    public let player: Player
 
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameBoard: Gameboard?
    private(set) weak var gameBoardView: GameboardView?
    public let markView: MarkView
 
    init(player: Player, gameViewController: GameViewController?, gameBoard: Gameboard?, gameBoardView: GameboardView?, markView: MarkView) {
        var position: GameboardPosition
        self.player = player
        self.gameViewController = gameViewController
        self.gameBoard = gameBoard
        self.gameBoardView = gameBoardView
        self.markView = markView
        guard let gameBoardView = gameBoardView else { return }
        if player == .second {
            repeat {
                let column = arc4random_uniform(UInt32(GameboardSize.columns))
                let row = arc4random_uniform(UInt32(GameboardSize.rows))
                position = GameboardPosition(column: Int(column), row: Int(row))
            } while !gameBoardView.canPlaceMarkView(at: position)
            addSign(at: position)
        }
    }
 
 
 func addSign(at position: GameboardPosition) {
     guard let gameBoardView = gameBoardView,
           gameBoardView.canPlaceMarkView(at: position)
     else { return }
     
     gameBoard?.setPlayer(player, at: position)
     Logger.shared.log(action: .playerSetSign(player: player, position: position))
     gameBoardView.placeMarkView(markView.copy(), at: position)
     isMoveCompleted = true
 }
    
 func begin() {
     switch player {
     case .first:
         gameViewController?.firstPlayerTurnLabel.isHidden = false
         gameViewController?.secondPlayerTurnLabel.isHidden = true
     case .second, .ai:
         gameViewController?.firstPlayerTurnLabel.isHidden = true
         gameViewController?.secondPlayerTurnLabel.isHidden = false
     }
     
     gameViewController?.winnerLabel.isHidden = true
 }
    
    
}
