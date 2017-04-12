//
//  ViewController.swift
//  A_BullsEye
//
//  Created by Kam Lotfull on 09.04.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Main functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setDefaultValue( defaultQHighscoreArrayOfDict, forKey: "qhighscoredict")
        sliderValueLabel.isHidden = true
        setSliderDesign()
        startNewGame()
    }
    private func startNewGame() {
        resetMainValues()
        setHighlightedColorToSelectedGameButton()
        changeHighscore(for: gameType)
        switch gameType {
        case QGame:
            QGameStartRound()
        case TGame:
            TGameStart()
        case VSGame:
            VSGameStart()
        default:
            print("switch gametype default")
        }
    }
    private func setGameTypeByGameButton(withLabel labelText: String) -> Int {
        switch labelText {
        case "Quality":
            return QGame
        case "Time":
            return TGame
        case "1 VS 1":
            return VSGame
        default:
            print("setGameTypeByButton default print")
            return QGame
        }
    }
    private func resetMainValues() {
        round = 1
        score = 0
        roundScore = 0
        currentStreak = 0
        isHighscore = false
        bonusLabelHidden(true)
    }
    private func setRandomValues() {
        aimValue = 1 + Int(arc4random_uniform(100))
        defaultValue = (aimValue + 40 + Int(arc4random_uniform(20))) % 100
        slider.value = Float(defaultValue) // default slider value
        currentValue = defaultValue
    }
    private func calculateQGameRoundScore() {
        difference = abs(aimValue - currentValue)
        switch difference {
        case 0...20:
            roundScore = (10 * Int(pow(pow100in3_5 - Double(difference), 1/power)) + bonus * currentStreak)
            print(roundScore)
            switch difference {
            case 0:
                currentStreak += 2
            case 1:
                currentStreak += 1
            default:
                currentStreak = 0
            }
        case 21..<100:
            roundScore = (100 - difference) / 3 + bonus * currentStreak
            currentStreak = 0
        default:
            break
        }
        bonusLabelHidden(currentStreak == 0)
    }

    // MARK: - Qgame
    private func QGameStartRound() {
        QGamesetValues()
        QGamesetLabels()
    }
    private func QGamesetValues() {
        setRandomValues()
    }
    private func QGamesetLabels() {
        aimLabel.text = String(aimValue)
        ScoreLabel.text = String(score)
        RoundLabel.text = "\(round) of \(QGRoundsQuantity)"
        
        if isHighscore {
            highscoreLabel.text = "\(highscoreName) \(highscoreScore)"
        }
        bonusLabelHidden(currentStreak == 0)
        roundScoreLabel.text = "+ \(roundScore)"
        timeLeftTextLabel.isHidden = true
        timeLeftNumberLabel.isHidden = true
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
        let message = "Your made new highscore: \(score)\nEnter your name!"
        let alert = UIAlertController(
            title: "Highscore # \(highScorePos)!",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "OK", style: .default, handler: {
                [weak alert] (_) in
                let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
                print("Text field: \(textField.text!)")
                if self.highScorePos == 1 {
                    self.highscoreName = textField.text!
                    self.highscoreScore = self.score
                }
                self.addHighscoreToDefaultsForKey("qhighscoredict", score: self.score, name: textField.text!)
                self.startNewGame()
            })
        alert.addTextField { (textField) in textField.text = "" }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Highscore
    private func changeHighscore(for GameType: Int) {
        switch GameType {
        case QGame:
            highscoreTypeLabel.text = "Quality Game\nHighscore:"
            getHighscoreArrayFromDefaults(forKey: "qhighscoredict")
        case TGame:
            highscoreTypeLabel.text = "Time Game\nHighscore:"
            getHighscoreArrayFromDefaults(forKey: "thighscoredict")
        case VSGame:
            highscoreTypeLabel.text = "1 VS 1 Game\nHighscore:"
            getHighscoreArrayFromDefaults(forKey: "vshighscoredict")
        default:
            print("changeHighscore() default case")
        }
    }
    private func getHighscoreArrayFromDefaults(forKey: String) {
        if  let testHighscoreDict = UserDefaults.standard.array(forKey: forKey),
            let highscoreDict = testHighscoreDict as? [[String: Any]] {
            currentHighscoreArrayOfDict = highscoreDict
            highscore = currentHighscoreArrayOfDict[0]
            if let HighscoreName = highscore["name"] as? String, let HighscoreScore = highscore["score"] as? Int {
                highscoreName = HighscoreName
                highscoreScore = HighscoreScore
                highscoreLabel.text = "\(highscoreName) \(highscoreScore)"
                print(currentHighscoreArrayOfDict, "of game type \(gameType)")
            } else {
                print("incorrect highscore[0] from default ERR")
            }
        } else {
            print("askHighscoreArrayFromDefaults ERR")
        }
    }
    private func scoreSorting(_ dict1: [String: Any], _ dict2: [String: Any]) -> Bool {
        if let score1 = dict1["score"] as? Int,
            let score2 = dict2["score"] as? Int {
            return score1 > score2
        } else {
            print("scoreSorting ERRR")
            return true
        }
    }
    private func addHighscoreToDefaultsForKey(_ key: String, score: Int, name: String) {
        let newHighscore: [String : Any] = ["score": score, "name" : name]
        currentHighscoreArrayOfDict.removeLast()
        currentHighscoreArrayOfDict.append(newHighscore)
        currentHighscoreArrayOfDict.sort(by: scoreSorting)
        setDefaultValue(currentHighscoreArrayOfDict, forKey: "qhighscoredict")
        highscoreLabel.text = "\(highscoreName) \(highscoreScore)"
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
    private func askForName() -> String {
        return "TestName"
    }
    
    // MARK: - Alerts and alert actions
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
                if self.isHighscore {
                    self.highscoreAlert()
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

    // MARK: - Design
    private func bonusLabelHidden(_ bool: Bool) {
        bonusNumberLabel.isHidden = bool
        bonusTextLabel.isHidden = bool
        bonusNumberLabel.text = "\(currentStreak)"
    }
    
    private func setNormalColorToLastGameButton() {
        switch gameType {
        case QGame:
            QGameButton.backgroundColor? = (QGameButton.backgroundColor?.withAlphaComponent(0.4))!
        case TGame:
            TGameButton.backgroundColor? = (TGameButton.backgroundColor?.withAlphaComponent(0.4))!
        case VSGame:
            VSGameButton.backgroundColor? = (VSGameButton.backgroundColor?.withAlphaComponent(0.4))!
            VSGameButton.titleLabel?.textColor = UIColor.white
        default:
            print("setCurrentButtonNormalColor() default")
        }
    }
    private func setHighlightedColorToSelectedGameButton() {
        switch gameType {
        case QGame:
            QGameButton.backgroundColor? = (QGameButton.backgroundColor?.withAlphaComponent(1))!
        case TGame:
            TGameButton.backgroundColor? = (TGameButton.backgroundColor?.withAlphaComponent(1))!
        case VSGame:
            VSGameButton.backgroundColor? = (VSGameButton.backgroundColor?.withAlphaComponent(1))!
            VSGameButton.titleLabel?.textColor = UIColor.blue //UIColor(red: 0, green: 8, blue: 133, alpha: 1)
        default:
            print("setCurrentButtonNormalColor() default")
        }
    }
    private func setSliderDesign() {
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        let trackLeftResizable = #imageLiteral(resourceName: "SliderTrackLeft").resizableImage(withCapInsets: insets)
        let trackRightResizable = #imageLiteral(resourceName: "SliderTrackRight").resizableImage(withCapInsets: insets)
        slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        slider.setMaximumTrackImage(trackRightResizable, for: .normal)
    }
    private func setDefaultValue(_ value: Any?, forKey key: String) {

        if var arrayOfDict = value as? [[String: Any]] {
            arrayOfDict.sort(by: scoreSorting)
            UserDefaults.standard.set(arrayOfDict, forKey: key)
        } else {
            print("setDefaultValue errr")
        }
        if let loadedArrayOfDict = UserDefaults.standard.array(forKey: key) as? [[String: Any]] {
            print(loadedArrayOfDict)
        }

        UserDefaults.standard.synchronize()
    }
    
    // MARK: - Other Games
    private func TGamesetValues() {
        resetMainValues()
    }
    private func TGamesetLabels() {
        aimLabel.text = String(aimValue)
        timeLeftTextLabel.isHidden = true
        timeLeftNumberLabel.isHidden = true
    }
    private func TGameStart() {
        TGamesetValues()
        TGamesetLabels()
    }
    private func setVSGameValues() {
        
    }
    private func setVSGameLabels() {
        
    }
    private func VSGameStart() {
        setVSGameValues()
        setVSGameLabels()
    }
    
    // MARK: - Actions
    @IBAction func GameButtonPressed(_ button: UIButton) {
        setNormalColorToLastGameButton()
        gameType = setGameTypeByGameButton(withLabel: (button.titleLabel?.text)!)
        setHighlightedColorToSelectedGameButton()
        startNewGame()
    }
    @IBAction func sliderMoved(_ slider: UISlider) {
        currentValue = lrintf(slider.value)
        sliderValueLabel.text = String(slider.value)
    }
    @IBAction func restartButton(_ sender: UIButton) {
        startNewGame()
    }
    @IBAction func MainButtonPressed() {
        switch gameType {
        case QGame:
            calculateQGameRoundScore()
            score += roundScore
            if round == QGRoundsQuantity {
                if score > highscore["score"] as! Int {
                    QGameGoodEndAlert()
                } else {
                    QGameBadEndAlert()
                }
            } //else { QRoundEndAlert(withAction: nextRoundAction()) }
            round += 1;
            if score > highscore["score"] as! Int {
                /*if !isHighscore { highscoreAlert() }
                highscore["score"] = score
                highscore["name"] = askForName()
                isHighscore = true*/
                highscoreScore = score
                highscoreLabel.text = "Your score \(score)"
                //addQHighscoreToDict(score: highscore["score"] as! Int, name: highscore["name"] as! String)
            }
            self.QGameStartRound()
        default:
            print("Another game type, not installed")
        }
        
        if gameType == QGame
        {
                    }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var aimLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var RoundLabel: UILabel!
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var roundScoreLabel: UILabel!
    @IBOutlet weak var highscoreTypeLabel: UILabel!
    @IBOutlet weak var TGameButton: UIButton!
    @IBOutlet weak var QGameButton: UIButton!
    @IBOutlet weak var VSGameButton: UIButton!
    @IBOutlet weak var timeLeftTextLabel: UILabel!
    @IBOutlet weak var timeLeftNumberLabel: UILabel!
    
    @IBOutlet weak var bonusNumberLabel: UILabel!
    @IBOutlet weak var bonusTextLabel: UILabel!
    // MARK: - var stack
    var defaultValue = 50
    var currentValue: Int = 0
    var aimValue: Int = 0
    var round: Int = 0
    var score: Int = 0
    var roundScore: Int = 0
    var difference: Int = 0
    var gameType = 1 //
    let QGame = 1
    let TGame = 0
    let VSGame = 2
    let QGRoundsQuantity: Int = 10
    //var minHighscore = 0
    var highscore: [String: Any] = ["score": 0, "name" : "None"]
    var isHighscore = false
    var highscoreName = "None"
    var highscoreScore = 0
    var QHighscoreArrayOfDict : [[String: Any]] = []
    let defaultQHighscoreArrayOfDict : [[String: Any]] = [
        ["score": 1000, "name" :  "Kam"],
        ["score": 200, "name" :  "Lotfull"],
        ["score": 50, "name" :  "Nikita"],
        ["score": 150, "name" :  "Darina"],
        ["score": 100, "name" :  "Lyokha"]
    ]
    var currentHighscoreArrayOfDict : [[String: Any]] = []
    var pow100in3_5 = pow(100.01, (3.0/5))
    var power: Double = 3/5
    var currentStreak = 0
    var bonus = 50
    var highScorePos = 1
}

