//
//  MainMenuViewController.swift
//  XO-game
//
//  Created by Denis Kuzmin on 24.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
   
    private var gameType: GameType?
    
    @IBAction func twoPlayersButton(_ sender: Any) {
        gameType = .twoPlayers
        performSegue(withIdentifier: "startGame", sender: nil)
    }
    
    @IBAction func aiButton(_ sender: Any) {
        gameType = .ai
        performSegue(withIdentifier: "startGame", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? GameViewController,
              let gameType = gameType
              else { return }
        destinationVC.gameType = gameType
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
