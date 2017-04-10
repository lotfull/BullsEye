//
//  ViewController.swift
//  A_BullsEye
//
//  Created by Kam Lotfull on 09.04.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var defaultValue = 50
    var currentValue: Int = 0
    var aimValue: Int = 0
    var round: Int = 0
    var score: Int = 0
    var roundScore: Int = 0
    var difference: Int = 0
    var highscore: Int = 0
    var isHighscore: Int = 0
    @IBOutlet weak var aimLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var RoundLabel: UILabel!
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var highscoreLabel: UILabel!
    
    private func setValues() {
        aimValue = 1 + Int(arc4random_uniform(100))
        defaultValue = (aimValue + 40 + Int(arc4random_uniform(20))) % 100
        slider.value = Float(defaultValue) // default slider value
        currentValue = defaultValue
        score += roundScore // increase score
        round += 1; // increase round
        if score > highscore {
            highscore = score
            isHighscore += 1
            let highscoreDefault = UserDefaults.standard
            highscoreDefault.setValue(highscore, forKey: "highscore")
            highscoreDefault.synchronize()
        }
    }
    
    private func highscoreAlert() {
        let message = "You made a HighScore! King of the Bulls eye!"
        let alert = UIAlertController(
            title: "Amazing!",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "Continue",
            style: .default,
            handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func setLabels() {
        aimLabel.text = String(aimValue)
        ScoreLabel.text = String(score)
        RoundLabel.text = String(round)
        if isHighscore > 0 {
            if isHighscore == 1 { highscoreAlert() }
            highscoreLabel.text = String(score)
        }
    }
    
    private func setSliderDesign() {
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        let trackLeftResizable = #imageLiteral(resourceName: "SliderTrackLeft").resizableImage(withCapInsets: insets)
        let trackRightResizable = #imageLiteral(resourceName: "SliderTrackRight").resizableImage(withCapInsets: insets)
        slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        slider.setMaximumTrackImage(trackRightResizable, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sliderValueLabel.isHidden = true
        let highscoreDefault = UserDefaults.standard
        if let testHighscore = highscoreDefault.value(forKey: "Highscore") {
            highscore = testHighscore as! Int
        }
        setSliderDesign()
        startOfNewRound()
    }
    
    private func startOfNewRound() {
        setValues()
        setLabels()
    }
    
    private func calculateRoundScore() {
        difference = abs(aimValue - currentValue)
        let differenceSquare = difference * difference
        roundScore = (differenceSquare < 400) ?
            10 * Int(pow(pow(101, 2/3) - Double(difference), 1.5))
            : (100 - difference) / 3
        if difference == 0 {
            roundScore += 250
        }
    }

    // MARK - ALERT
    @IBAction func showAlert() {
        calculateRoundScore()
        let message = "The value of slider is: \(currentValue)\nThe aim was: \(aimValue)"
        let alert = UIAlertController(
            title: "\(roundScore) points!",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "Ok",
            style: .default,
            handler: {
                action in
                self.startOfNewRound()
            })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func sliderMoved(_ slider: UISlider) {
        currentValue = lrintf(slider.value)
        sliderValueLabel.text = String(slider.value)
    }
    @IBAction func restartButton(_ sender: UIButton) {
        round = 0
        score = 0
        roundScore = 0
        isHighscore = 0
        startOfNewRound()
    }
    @IBAction func howToPlayButton(_ sender: UIButton) {
        let message = "Show your bulls eye!\nPut slider as close as you can\nGet 100% score\nAchieve bonus"
        let alert = UIAlertController(
            title: "The rules",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "Ok",
            style: .default,
            handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    @IBOutlet weak var backgroundImage: UIImageView!
    
    
}

