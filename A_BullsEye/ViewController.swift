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
    var isHighscore = false
    var gameType = true //
    let QualityGame = true
    let TimeGame = false
    let QGRoundsQuantity: Int = 10
    @IBOutlet weak var aimLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var RoundLabel: UILabel!
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBAction func sliderMoved(_ slider: UISlider) {
        currentValue = lrintf(slider.value)
        sliderValueLabel.text = String(slider.value)
    }
    @IBAction func restartButton(_ sender: UIButton) {
        startNewGame()
    }
    private func resetMainValues() {
        round = 0
        score = 0
        roundScore = 0
        isHighscore = false
    }
    private func setRandomValues() {
        aimValue = 1 + Int(arc4random_uniform(100))
        defaultValue = (aimValue + 40 + Int(arc4random_uniform(20))) % 100
        slider.value = Float(defaultValue) // default slider value
        currentValue = defaultValue
    }
    private func highscoreAlert() {
        let message = "\nKing of the Bull's eye!"
        let alert = UIAlertController(
            title: "HighScore!",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "Continue",
            style: .default,
            handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    private func setSliderDesign() {
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        let trackLeftResizable = #imageLiteral(resourceName: "SliderTrackLeft").resizableImage(withCapInsets: insets)
        let trackRightResizable = #imageLiteral(resourceName: "SliderTrackRight").resizableImage(withCapInsets: insets)
        slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        slider.setMaximumTrackImage(trackRightResizable, for: .normal)
    }
    private func QRoundEndAlert(withAction action: UIAlertAction) {
        let message = "The value of slider is: \(currentValue)\nThe aim was: \(aimValue)"
        let alert = UIAlertController(
            title: "\(roundScore) points!",
            message: message,
            preferredStyle: .alert)
            alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    private func nextRoundAction() -> UIAlertAction {
    return UIAlertAction(
        title: "Next round",
        style: .default,
        handler: {
            action in
            self.QGameStartRound()
        })

    }
    private func ShowGameResultsAction() -> UIAlertAction {
        return UIAlertAction(
            title: "Show results",
            style: .default,
            handler: {
                action in
                if !self.isHighscore {
                    self.QGameBadEndAlert()
                } else {
                    self.QGameGoodEndAlert()
                }
                self.startNewGame()
        })
    }
    private func CongratsWithHighScoreAction() -> UIAlertAction {
        return UIAlertAction(
            title: "New Highscore!",
            style: .default,
            handler: {
                action in
                self.QGameGoodEndAlert()
                self.QGameStartRound()
        })
    }

    private func QGameBadEndAlert() {
        let message = "Your score \(score)\nThe score to beat: \(highscore)"
        let alert = UIAlertController(
            title: "Quality game over!",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "Ok",
            style: .default,
            handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    private func QGameGoodEndAlert() {
        let message = "Your made new highscore: \(score)\nCongratulations!"
        let alert = UIAlertController(
            title: "You Rock!",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "Ok",
            style: .default,
            handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func cleanHighscore(forKey: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(0, forKey: forKey)
        defaults.synchronize()
    }
    
    @IBAction func MainButtonPressed() {
        if gameType == QualityGame
        {
            calculateRoundScore()
            score += roundScore
            if round == QGRoundsQuantity {
                QRoundEndAlert(withAction: ShowGameResultsAction())
            } else if score > highscore {
                QRoundEndAlert(withAction: CongratsWithHighScoreAction())
            } else {
                QRoundEndAlert(withAction: nextRoundAction())
            }
            round += 1;
            if score > highscore {
                if !isHighscore { highscoreAlert() }
                highscore = score
                isHighscore = true
                let defaults = UserDefaults.standard
                defaults.setValue(highscore, forKey: "qhighscore")
                defaults.synchronize()
            }
        }
    }
    
    private func setHighscoreValueFromDefaults(forKey: String) {
        if let testHighscore = UserDefaults.standard.value(forKey: forKey) {
            highscore = testHighscore as! Int
            highscoreLabel.text = String(highscore)
        }
    }
    
    private func changeHighscore(to GameType: Bool) {
        switch GameType {
        case QualityGame:
            print("Qiality Game highscore")
            highscoreTypeLabel.text = "Quality Game\nHighscore:"
            setHighscoreValueFromDefaults(forKey: "qhighscore")
        case TimeGame:
            print("Time Game Highscore")
            highscoreTypeLabel.text = "Time Game\nHighscore:"
            setHighscoreValueFromDefaults(forKey: "thighscore")
        default:
            print("Highscore game error")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        cleanHighscore(forKey: "qhighscore")
        sliderValueLabel.isHidden = true
        setSliderDesign()
        startNewGame()
    }
    
    private func startNewGame() {
        resetMainValues()
        gameType = GameSwitch.isOn
        changeHighscore(to: gameType)
        if gameType == QualityGame {
            QGameStartRound()
        } else if gameType == TimeGame {
            TGameStart()
        }
    }
    
    private func QGameStartRound() {
        setQGameValues()
        setQGameLabels()
    }
    private func setQGameValues() {
        setRandomValues()
    }
    
    private func setQGameLabels() {
        aimLabel.text = String(aimValue)
        ScoreLabel.text = String(score)
        RoundLabel.text = "\(round) of \(QGRoundsQuantity)"
        if isHighscore {
            highscoreLabel.text = String(score)
        }
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
    

    
    
    
    private func setTGameValues() {
        
    }
    private func setTGameLabels() {
        
    }
    private func TGameStart() {
        setTGameValues()
        setTGameLabels()
    }
    
    @IBAction func gameSwitched(_ sender: UISwitch) {
        startNewGame()
    }
    @IBOutlet weak var GameSwitch: UISwitch!
    
    @IBOutlet weak var highscoreTypeLabel: UILabel!
    
}

