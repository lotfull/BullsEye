//
//  ViewController.swift
//  A_BullsEye
//
//  Created by Kam Lotfull on 09.04.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import QuartzCore

class MainViewController: UIViewController {
    
    // MARK: - Main functions
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultValue(defaultCleanQHighscoreArrayOfDict, forKey: QGHighscoreKey + "10")
        setDefaultValue(defaultCleanQHighscoreArrayOfDict, forKey: QGHighscoreKey + "7")
        setDefaultValue(defaultCleanQHighscoreArrayOfDict, forKey: QGHighscoreKey + "5")
        sliderValueLabel.isHidden = true
        setSliderDesign()
        startNewGame()
        VSGameButton.isEnabled = false
        TGameButton.isEnabled = false
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
    private func ChangeQRoundsQuantity() {
        iter += 1
        iter %= QRoundsQuantitiesArray.count
        QRoundsQuantity = QRoundsQuantitiesArray[iter]
        QRoundsQuantityLabel.text = "\(QRoundsQuantity)"
    }
    private func setGameTypeByGameButton(withLabel labelText: String) -> Int {
        switch labelText {
        case "Quality":
            ChangeQRoundsQuantity()
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
        roundScoreLabelHidden(true)
        
    }
    private func setRandomValues() {
        aimValue = 1 + Int(arc4random_uniform(100))
        while aimValue == 1 || aimValue == 100 {
            aimValue = 1 + Int(arc4random_uniform(100))
        }
        
        defaultValue = (aimValue + 40 + Int(arc4random_uniform(20))) % 100
        slider.value = Float(defaultValue) // default slider value
        currentValue = defaultValue
    }
    private func calculateQGameRoundScore() {
        difference = currentValue - aimValue
        absDifference = abs(difference)
        switch absDifference {
        case 0...20:
            roundScore = 10 * Int(pow(pow100in3_5 - Double(absDifference), 1/power))
            print(roundScore)
            switch absDifference {
            case 0:
                currentStreak += 2
            case 1:
                currentStreak += 1
            default:
                currentStreak = 0
            }
        case 21..<100:
            roundScore = (100 - absDifference) / 3
            currentStreak = 0
        default:
            break
        }
        bonusScoreLabelHidden(currentStreak == 0)
    }

    // MARK: - Qgame
    private func QGameStartRound() {
        QGamesetValues()
        QGamesetLabels()
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        view.layer.add(transition, forKey: nil)
    }
    private func QGamesetValues() {
        setRandomValues()
    }
    private func QGamesetLabels() {
        aimLabel.text = String(aimValue)
        ScoreLabel.text = String(score)
        RoundLabel.text = "\(round) of \(QRoundsQuantity)"
        if isHighscore {
            highscoreLabel.text = "\(highscoreName) \(highscoreScore)"
        }
        roundScoreLabelHidden(round == 1)
        bonusScoreLabelHidden(currentStreak == 0)
        roundScoreLabel.text = "+ \(roundScore)"
        timeLeftTextLabel.isHidden = true
        timeLeftNumberLabel.isHidden = true
        differenceLabel.text = (difference > 0) ?
            "(+\(difference)) : " : "(\(difference)) : "
        
        
    }
    private func QGameBadEndAlert() {
        let message = "Your score \(score)\nThe score to beat: \(lastHighscore)"
        let alert = UIAlertController(
            title: "Game over!",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "OK",
            style: .default,
            handler: {
                (_) in
                self.startNewGame()
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    private func QGameGoodEndAlert(message: String) {
        
        let message = "Your made new \(message): \(score)\nEnter your name!"
        let alert = UIAlertController(
            title: "Highscore!",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "OK", style: .default, handler: {
                [weak alert] (_) in
                let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
                print("Text field: \(textField.text!)")
                self.addHighscoreToDefaultsForKey(self.QGHighscoreKey + "\(self.QRoundsQuantity)", score: self.score, name: textField.text!)
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
            let key = QGHighscoreKey + "\(QRoundsQuantity)"
            print(key)
            getHighscoreArrayFromDefaults(forKey: key)
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
    func getHighscoreArrayFromDefaults(forKey key: String) {
        if  let testHighscoreDict = UserDefaults.standard.array(forKey: key),
            let highscoreDict = testHighscoreDict as? [[String: Any]] {
            currentHighscoreArrayOfDict = highscoreDict
            highscore = currentHighscoreArrayOfDict[0]
            lastHighscore = currentHighscoreArrayOfDict[4]["score"] as! Int
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
        setDefaultValue(currentHighscoreArrayOfDict, forKey: QGHighscoreKey + "\(QRoundsQuantity)")
        highscoreLabel.text = "\(highscoreName) \(highscoreScore)"
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        if let leaderboardVC = destinationViewController as? LeaderboardViewController {
            leaderboardVC.qHighscoreArray = currentHighscoreArrayOfDict
        }
    }
    
    // MARK: - Alerts and alert actions

    // MARK: - Design
    private func roundScoreLabelHidden(_ bool: Bool) {
        differenceLabel.isHidden = bool
        roundScoreLabel.isHidden = bool
    }
    private func bonusScoreLabelHidden(_ bool: Bool) {
        bonusNumberLabel.isHidden = bool
        bonusTextLabel.isHidden = bool
        bonusNumberLabel.text = "\(currentStreak)"
    }
    private func setNormalColorToLastGameButton() {
        switch gameType {
        case QGame:
            QGameButton.backgroundColor? = (QGameButton.backgroundColor?.withAlphaComponent(0.4))!
            QRoundsQuantityLabel.backgroundColor? = (QRoundsQuantityLabel.backgroundColor?.withAlphaComponent(0.4))!
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
            QRoundsQuantityLabel.backgroundColor? = (QRoundsQuantityLabel.backgroundColor?.withAlphaComponent(1))!
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
            score += roundScore + bonus * currentStreak
            if round == QRoundsQuantity {
                if score > highscore["score"] as! Int {
                    QGameGoodEndAlert(message: "Best Highscore")
                } else if score > lastHighscore {
                    QGameGoodEndAlert(message: "Highscore")
                } else {
                    QGameBadEndAlert()
                }
            } else {
                round += 1;
            }
            if score > highscore["score"] as! Int {
                highscoreScore = score
                highscoreLabel.text = "Your score \(score)"
            }
            self.QGameStartRound()
        default:
            print("Another game type, not installed")
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
    @IBOutlet weak var differenceLabel: UILabel!
    @IBOutlet weak var bonusNumberLabel: UILabel!
    @IBOutlet weak var bonusTextLabel: UILabel!
    @IBOutlet weak var QRoundsQuantityLabel: UILabel!
    
    // MARK: - var stack
    var defaultValue = 50
    var currentValue: Int = 0
    var aimValue: Int = 0
    var round: Int = 0
    var score: Int = 0
    var roundScore: Int = 0
    var difference: Int = 0
    var absDifference: Int = 0
    var gameType = 1 //
    let QGame = 1
    let TGame = 0
    let VSGame = 2
    var QRoundsQuantity: Int = 10
    var lastHighscore = 0
    var highscore: [String: Any] = ["score": 0, "name" : "None"]
    var isHighscore = false
    var highscoreName = "None"
    var highscoreScore = 0
    var QHighscoreArrayOfDict : [[String: Any]] = []
    let defaultQHighscoreArrayOfDict10 = [[String: Any]]()
    let defaultCleanQHighscoreArrayOfDict : [[String: Any]] = [
        ["name": "Tinky", "score": 2000],
        ["name": "Winky", "score": 1500],
        ["name": "Lylya", "score": 1000],
        ["name": "Po", "score": 500],
        ["name": "Lysyi", "score": 100]
    ]
    var currentHighscoreArrayOfDict : [[String: Any]] = []
    var pow100in3_5 = pow(100.01, (3.0/5))
    var power: Double = 3/5
    var currentStreak = 0
    var bonus = 50
    var highScorePos = 1
    let QGHighscoreKey = "qhighscoredict"
    let QRoundsQuantitiesArray = [5, 7, 10]
    var iter = 2;
}

