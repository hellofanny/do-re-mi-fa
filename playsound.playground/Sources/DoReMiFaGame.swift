import Foundation
import AVFoundation
import UIKit


public protocol DoReMiFaGameDelegate {
    func gameOver()
    func userWonTheGame()
    func newLevel()
}

public class DoReMiFaGame {
    
    //save the sound sequence of the game
    var soundsSequence = [Int]()
    
    var numberOfButtonsPressed = 0
    var currentItem = 0
    var currentLevel = 0
    let defaultMaxLevel = 5
    
    var gameState = GameState.NotPlaying
    
    var sounds : [AVAudioPlayer]
    
    //colored buttons
    let pinkBtn: UIButton
    let yellowBtn: UIButton
    let greenBtn: UIButton
    let purpleBtn: UIButton
    
    let coloredButtons: [UIButton]
    
    var delegate : DoReMiFaGameDelegate?
    
    public init (sounds: [AVAudioPlayer], pinkBtn: UIButton, yellowBtn: UIButton, greenBtn: UIButton, purpleBtn: UIButton, delegate: DoReMiFaGameDelegate)
    {
        self.sounds = sounds
        self.pinkBtn = pinkBtn
        self.yellowBtn = yellowBtn
        self.greenBtn = greenBtn
        self.purpleBtn = purpleBtn
        
        self.delegate = delegate
        
        self.coloredButtons = [self.pinkBtn, self.yellowBtn, self.greenBtn, self.purpleBtn]
    }
    
    func addSoundToSequence() {
        let randomNumber = Int(arc4random_uniform(4))
        self.soundsSequence.append(randomNumber)
    }
    
    public func startNewLevel() {
        self.currentLevel += 1
        self.delegate?.newLevel()
        
        print("New level: \(currentLevel)")
        self.currentItem = 0
        self.numberOfButtonsPressed = 0
        self.disableColorButtons()
        
        self.addSoundToSequence()
        print("Sound Sequence:",soundsSequence)
        
        self.gameState = GameState.SequencePlaying
        self.playNextItem()
    }
    
    public func getGameState() -> GameState {
        return self.gameState
    }
    
    public func getCurrentLevel() -> Int {
        return self.currentLevel
    }
    
    public func continueToCheck() -> Bool {
        return self.currentLevel > self.numberOfButtonsPressed
    }
    
    public func resetGame() {
        self.currentLevel = 0
        self.currentItem = 0
        self.numberOfButtonsPressed = 0
        self.soundsSequence = []
    }
    
    public func afterSoundIsPlayed() {
        self.resetButtonsHighlights()
        
        if self.currentItem <= self.soundsSequence.count - 1 {
            //adding delay between the sounds
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
                self.playNextItem()
            }
        } else {
            //User turn
            self.gameState = GameState.UserPlaying
            self.enableColorButtons()
        }
    }
    
    public func playNextItem () {
        let playedSound = soundsSequence[currentItem]
        print("played sound :", playedSound)
    
        self.resetButtonsHighlights()
        self.highlightButton(buttonTag: playedSound)
        self.sounds[playedSound].play()
        self.currentItem += 1
    }
    
    func resetButtonsHighlights() {
        self.pinkBtn.setImage(UIImage(named: "pink_btn"), for: .normal)
        self.yellowBtn.setImage(UIImage(named: "yellow_btn"), for: .normal)
        self.greenBtn.setImage(UIImage(named: "green_btn"), for: .normal)
        self.purpleBtn.setImage(UIImage(named: "purple_btn"), for: .normal)
    }
    
    func highlightButton(buttonTag: Int) {
        switch buttonTag {
        case 0:
            self.resetButtonsHighlights()
            self.pinkBtn.setImage(UIImage(named:"pink_btn_on"), for: .normal)
            break
        case 1:
            self.resetButtonsHighlights()
            self.yellowBtn.setImage(UIImage(named:"yellow_btn_on"), for: .normal)
            break
        case 2:
            self.resetButtonsHighlights()
            self.greenBtn.setImage(UIImage(named:"green_btn_on"), for: .normal)
            break
        case 3:
            self.resetButtonsHighlights()
            self.purpleBtn.setImage(UIImage(named:"purple_btn_on"), for: .normal)
            break
        default:
            break
        }
    }
    
    public func checkPressedButton(buttonPressed: Int) {
        
        if buttonPressed == self.soundsSequence[self.numberOfButtonsPressed] {
            if self.numberOfButtonsPressed == (self.defaultMaxLevel - 1) {
                //print("WON THE GAME")
                self.delegate?.userWonTheGame()
                self.disableColorButtons()
                
            } else if self.numberOfButtonsPressed == self.soundsSequence.count - 1 {
                //at the last item of the sequence
                //    self.disableColorButtons()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    //delay for the next level... add animation?
                    self.startNewLevel()
                }
            } 
            self.numberOfButtonsPressed += 1
            
        } else {
            //print("GAME OVER!")
            self.delegate?.gameOver()
            self.disableColorButtons()
        }
    }
    
    func enableColorButtons () {
        for button in coloredButtons {
            button.isUserInteractionEnabled = true
        }
    }
    
    func disableColorButtons () {
        for button in coloredButtons {
            button.isUserInteractionEnabled = false
        }
    }
    
}
