//
//  LeaderboardViewController.swift
//  A_BullsEye
//
//  Created by Kam Lotfull on 10.04.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

protocol resetHighscoresDelegate: class {
    func resetHighscores(_ newGameStart: Bool)
}

class LeaderboardViewController: UIViewController {
    
    weak var delegate: resetHighscoresDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        QHighscoreLabel1.text = "\(qHighscoreArray[0]["score"]!)"
        QHighscoreNameLabel1.text = "\(qHighscoreArray[0]["name"]!)"
        QHighscoreLabel2.text = "\(qHighscoreArray[1]["score"]!)"
        QHighscoreNameLabel2.text = "\(qHighscoreArray[1]["name"]!)"
        QHighscoreLabel3.text = "\(qHighscoreArray[2]["score"]!)"
        QHighscoreNameLabel3.text = "\(qHighscoreArray[2]["name"]!)"
        QHighscoreLabel4.text = "\(qHighscoreArray[3]["score"]!)"
        QHighscoreNameLabel4.text = "\(qHighscoreArray[3]["name"]!)"
        QHighscoreLabel5.text = "\(qHighscoreArray[4]["score"]!)"
        QHighscoreNameLabel5.text = "\(qHighscoreArray[4]["name"]!)"
    }
    
    @IBAction func closeLeaderboardButton(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetHighscoresButtonPressed() {
        delegate?.resetHighscores(true)
        closeLeaderboardButton(nil)
    }
 
    @IBOutlet weak var QHighscoreLabel1: UILabel!
    @IBOutlet weak var QHighscoreLabel2: UILabel!
    @IBOutlet weak var QHighscoreLabel3: UILabel!
    @IBOutlet weak var QHighscoreLabel4: UILabel!
    @IBOutlet weak var QHighscoreLabel5: UILabel!
    @IBOutlet weak var QHighscoreNameLabel1: UILabel!
    @IBOutlet weak var QHighscoreNameLabel2: UILabel!
    @IBOutlet weak var QHighscoreNameLabel3: UILabel!
    @IBOutlet weak var QHighscoreNameLabel4: UILabel!
    @IBOutlet weak var QHighscoreNameLabel5: UILabel!
    
    var qHighscoreArray = [[String: Any]]()
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    private func QHighscorersLoad() {
        
    }
}
