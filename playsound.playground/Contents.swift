//: A UIKit based Playground for presenting user interface

import UIKit
import AVFoundation
import PlaygroundSupport

let cfURL = Bundle.main.url(forResource: "Cardenio Modern Bold", withExtension: "ttf")! as CFURL
CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)

class MyViewController : UIViewController, AVAudioPlayerDelegate, DoReMiFaGameDelegate {
    
    let squareView = UIView()
    
    var doremifaMode : Mode = Mode.GameMode
    
    var sounds = [AVAudioPlayer]()
    let soundsNames = ["sound_pink", "sound_yellow", "sound_green", "sound_purple"]
    
    //colored buttons
    let pinkBtn = UIButton()
    let yellowBtn = UIButton()
    let greenBtn = UIButton()
    let purpleBtn = UIButton()
    
    let playBtn = UIButton()
    let label = UILabel()
    let modeBtn = UIButton()
    
    var game : DoReMiFaGame!
    
    override func loadView() {
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let logoView = UIImageView(image: UIImage(named: "doremifa_logo"))
        logoView.frame = CGRect(x: 150, y: 20, width: 180, height: 77)
        view.addSubview(logoView)
        
        self.modeBtn.setImage(UIImage(named: "gameMode_btn"), for: .normal)
        self.modeBtn.setImage(UIImage(named: "freestyle_btn"), for: .highlighted )
        self.modeBtn.frame = CGRect(x: 170, y: logoView.frame.origin.y + 85 , width: 152, height: 25)
        self.modeBtn.addTarget(self, action: #selector(self.changeMode), for: .touchUpInside)
        view.addSubview(modeBtn)
        
        self.label.frame = CGRect(x: 125, y: 400, width: 250, height: 20)
        self.label.textColor = .gray
        self.label.font = UIFont(name: "Cardenio Modern", size: 22)
        self.label.textAlignment = .center
        self.label.text = "Play with me!"
        view.addSubview(self.label)
        
        self.squareView.frame = CGRect(x: 150, y: 180, width: 200, height: 200)
        view.addSubview(self.squareView)
        
        self.playBtn.setImage(UIImage(named: "play_btn"), for: .normal)
        self.playBtn.frame = CGRect(x: (squareView.frame.width)/2 - 30, y: (squareView.frame.height/2) - 30, width: 60, height: 60)
        self.playBtn.addTarget(self, action: #selector(self.startGame), for: .touchUpInside)
        squareView.addSubview(self.playBtn)
        
        self.setupAudioFiles()
        self.setupButtons()
        self.game = DoReMiFaGame(sounds: sounds, pinkBtn: self.pinkBtn, yellowBtn: self.yellowBtn, greenBtn: self.greenBtn, purpleBtn: self.purpleBtn, delegate: self)
        
        self.view = view
        
    }
    
    func gameOver() {
        
        self.label.text = "Opps.. Game Over!"
        self.label.fadeOut()
        self.playBtn.setImage(UIImage(named: "replay_btn"), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.squareView.fadeOut()
          
            self.squareView.fadeIn(completion: {
                (finished: Bool) -> Void in
                self.label.text = "You can always try again!"
                self.label.fadeIn(completion: {
                    (finished: Bool) -> Void in
                    
                    self.playBtn.isHidden = false
                })
               
            })
        }
    }
    
    
    func newLevel() {
        self.label.text = "Level:  \(self.game.getCurrentLevel())"
    }
    
    func userWonTheGame() {
        self.label.text = "Congratulations!"
        self.playBtn.isHidden = false
        self.playBtn.setImage(UIImage(named: "replay_btn"), for: .normal)
    }
    
    @objc func buttonAction(sender: UIButton) {
        
        print(self.game.getGameState())
        
        if doremifaMode == Mode.Freestyle || self.game.getGameState() == GameState.NotPlaying {
            sounds[sender.tag].play()
            
        } else {
            sounds[sender.tag].play()
            if (self.game.continueToCheck() == true){
                self.game.checkPressedButton(buttonPressed: sender.tag)
            }
        }
    }
    
    @objc func changeMode() {
        if self.doremifaMode == Mode.GameMode {
            self.doremifaMode = Mode.Freestyle
            self.playBtn.isHidden = true
            self.label.text = "Make some noise."
            self.modeBtn.setImage(UIImage(named: "freestyle_btn"), for: .normal)
            self.modeBtn.setImage(UIImage(named: "gameMode_btn"), for: .highlighted)
        } else {
            self.doremifaMode = Mode.GameMode
            self.playBtn.isHidden = false
            self.playBtn.setImage(UIImage(named: "play_btn"), for: .normal)
            self.label.text = "Play with me."
            self.modeBtn.setImage(UIImage(named: "gameMode_btn"), for: .normal)
            self.modeBtn.setImage(UIImage(named: "freestyle_btn"), for: .highlighted )
        }
    }
    
    
    //Colored buttons set up
    func setupButtons() {
        
        //Pink button
        self.pinkBtn.setImage(UIImage(named: "pink_btn"), for: .normal)
        self.pinkBtn.setImage(UIImage(named: "pink_btn_on"), for: .highlighted)
        self.pinkBtn.frame = CGRect(x: (squareView.frame.width)/2 - 30, y: 0, width: 60, height: 60)
        self.pinkBtn.tag = 0
        self.pinkBtn.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        self.squareView.addSubview(pinkBtn)
        
        //Yellow button
        self.yellowBtn.setImage(UIImage(named: "yellow_btn"), for: .normal)
        self.yellowBtn.setImage(UIImage(named: "yellow_btn_on"), for: .highlighted)
        self.yellowBtn.frame = CGRect(x: (squareView.frame.width)/2 - 30, y: squareView.frame.height - 60 , width: 60, height: 60)
        self.yellowBtn.tag = 1
        self.yellowBtn.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        self.squareView.addSubview(yellowBtn)
        
        //Green button
        self.greenBtn.setImage(UIImage(named: "green_btn"), for: .normal)
        self.greenBtn.setImage(UIImage(named: "green_btn_on"), for: .highlighted)
        self.greenBtn.frame = CGRect(x: 0, y: (squareView.frame.height/2) - 30 , width: 60, height: 60)
        self.greenBtn.tag = 2
        self.greenBtn.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        self.squareView.addSubview(greenBtn)
        
        //Purple button
        self.purpleBtn.setImage(UIImage(named: "purple_btn"), for: .normal)
        self.purpleBtn.setImage(UIImage(named: "purple_btn_on"), for: .highlighted)
        self.purpleBtn.frame = CGRect(x: (squareView.frame.width)/2 + 40 , y: (squareView.frame.height/2) - 30 , width: 60, height: 60)
        self.purpleBtn.tag = 3
        self.purpleBtn.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        self.squareView.addSubview(purpleBtn)
    }
    
    //Audio Files set up
    func setupAudioFiles() {
        for sound in soundsNames {
            let soundURL = Bundle.main.url(forResource: sound, withExtension: "wav")!
            do {
                try self.sounds.append(AVAudioPlayer(contentsOf: soundURL))
            } catch {
                print(error)
            }
        }
        
        for audioPlayer in self.sounds {
            audioPlayer.delegate = self
            audioPlayer.numberOfLoops = 0
        }
    }
    
    
    @objc func startGame() {
        self.game.resetGame()
        self.playBtn.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.game.startNewLevel()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if game.getGameState() == GameState.SequencePlaying {
            self.game.afterSoundIsPlayed()
        }
        print(game.getGameState())
    }
    
}


// Present the view controller in the Live View window
let viewController = MyViewController()
viewController.preferredContentSize = CGSize(width: 500, height: 500)
PlaygroundPage.current.liveView = viewController
