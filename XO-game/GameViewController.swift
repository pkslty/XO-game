//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    var gameType: GameType!
    var counter = 0
    private let gameBoard = Gameboard()
    private lazy var referee = Referee(gameboard: gameBoard)
    
    private var currentState: PlayGameState! {
        didSet {
            currentState.begin()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstPlayerTurn()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }

            self.currentState.addSign(at: position)

            if self.currentState.isMoveCompleted {
                self.nextPlayerTurn()
                self.counter += 1
            }
        }
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        Logger.shared.log(action: .restartGame)
        
        gameboardView.clear()
        gameBoard.clear()
        counter = 0
        
        firstPlayerTurn()
    }
    
    private func firstPlayerTurn() {
        let firstPlayer: Player = .first
        
        let markView = getMarkView(player: firstPlayer)
        
        switch gameType {
        case .twoPlayers:
            currentState = PlayerGameState(player: firstPlayer,
                                           gameViewController: self,
                                           gameBoard: gameBoard,
                                           gameBoardView: gameboardView, markView: markView)
        case .ai:
            currentState = AIGameState(player: firstPlayer,
                                           gameViewController: self,
                                           gameBoard: gameBoard,
                                           gameBoardView: gameboardView, markView: markView)
        case .none:
            break
        }
        
    }
    
    private func nextPlayerTurn() {
        if let winner = referee.determineWinner() {
            currentState = GameEndState(winnerPlayer: winner, gameViewController: self)
            return
        }
        
        if counter >= 9 {
            Logger.shared.log(action: .gameFinished(won: nil))
            currentState = GameEndState(winnerPlayer: nil, gameViewController: self)
            return
        }
        
        if let playerState = currentState as? PlayerGameState {
            let next = playerState.player.next
            let markView = getMarkView(player: next)
            currentState = PlayerGameState(player: next, gameViewController: self,
                                           gameBoard: gameBoard, gameBoardView: gameboardView, markView: markView)
        }
        
        if let playerState = currentState as? AIGameState {
            let next = playerState.player.next
            let markView = getMarkView(player: next)
            currentState = AIGameState(player: next, gameViewController: self,
                                           gameBoard: gameBoard, gameBoardView: gameboardView, markView: markView)
            if self.currentState.isMoveCompleted {
                self.nextPlayerTurn()
                self.counter += 1
            }
        }
        
    }
    
    private func getMarkView(player: Player) -> MarkView {
        switch player {
        case .first:
            return XView()
        case .second, .ai:
            return OView()
        }
    }
}

