//
//  ViewController.swift
//  A_BullsEye
//
//  Created by Kam Lotfull on 09.04.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let defaultValue = 50
    var currentValue: Int = 0
    var aimValue: Int = 0
    var round: Int = 0
    var score: Int = 0
    var roundScore: Int = 0
    
    private func setValues() {
        aimValue = 1 + Int(arc4random_uniform(100))
        //slider.value = Float(defaultValue) // default slider value
        currentValue = defaultValue
        score += roundScore // increase score
        round += 1; // increase round
    }
    
    private func setLabels() {
        aimLabel.text = String(aimValue)
        ScoreLabel.text = String(score)
        RoundLabel.text = String(round)
    }

    override func viewDidLoad() {
        sliderValueLabel.isHidden = true
        super.viewDidLoad()
        startOfNewRound()
    }
    
    private func startOfNewRound() {
        setValues()
        setLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK - ALERT
    @IBAction func showAlert() {
        let message = "The value of slider is: \(currentValue)\nThe aim was: \(aimValue)"
        let alert = UIAlertController(
            title: "Bingo!",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        startOfNewRound()
    }
    @IBAction func sliderMoved(_ slider: UISlider) {
        currentValue = lrintf(slider.value)
        sliderValueLabel.text = String(slider.value)
    }
    @IBOutlet weak var aimLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var RoundLabel: UILabel!
    @IBAction func howToPlayButton(_ sender: UIButton) {
    }
    @IBAction func restartButton(_ sender: UIButton) {
    }
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
}

