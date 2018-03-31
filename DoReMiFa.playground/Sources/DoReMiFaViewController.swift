import UIKit
import AVFoundation

public class DoReMiFaViewController : UIViewController, AVAudioPlayerDelegate, DoReMiFaGameDelegate, DoReMiFaRecorderDelegate {
    
    let squareView = UIView()
    
    var doremifaMode : Mode = Mode.GameMode
    
    var sounds = [AVAudioPlayer]()
    let soundsNames = ["sound_pink", "sound_yellow", "sound_green", "sound_purple", "success_sound", "gameOver_sound", "beep_sound"]
    
    //colored buttons
    let pinkBtn = UIButton()
    let yellowBtn = UIButton()
    let greenBtn = UIButton()
    let purpleBtn = UIButton()
    
    let playGameBtn = UIButton()
    let infoLabel = UILabel()
    let modeBtn = UIButton()
    let levelLabel = UILabel()
    var starView = UIImageView()
    
    let recordBtn = UIButton()
    
    var game : DoReMiFaGame!
    var recorder : DoReMiFaRecorder!
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        
        self.view.layer.contents = UIImage(named: "background_img")?.cgImage
        
        let logoView = UIImageView(image: UIImage(named: "doremifa_logo"))
        logoView.frame = CGRect(x: 150, y: 35, width: 180, height: 77)
        self.view.addSubview(logoView)
        
        self.modeBtn.setImage(UIImage(named: "gameMode_btn"), for: .normal)
        self.modeBtn.setImage(UIImage(named: "freestyle_btn"), for: .highlighted )
        self.modeBtn.frame = CGRect(x: 170, y: logoView.frame.origin.y + 85 , width: 152, height: 25)
        self.modeBtn.addTarget(self, action: #selector(self.changeMode), for: .touchUpInside)
        self.view.addSubview(modeBtn)
        
        self.squareView.frame = CGRect(x: 150, y: 185, width: 200, height: 200)
        self.view.addSubview(self.squareView)
        
        self.infoLabel.frame = CGRect(x: 125, y: 408, width: 250, height: 20)
        self.infoLabel.textColor = .gray
        self.infoLabel.font = UIFont(name: "Cardenio Modern", size: 22)
        self.infoLabel.textAlignment = .center
        self.infoLabel.text = "Can you follow my notes?"
        self.view.addSubview(self.infoLabel)
        
        self.levelLabel.frame = CGRect(x: 145, y: 160, width: 150, height: 20)
        self.levelLabel.textColor = .gray
        self.levelLabel.font = UIFont(name: "Cardenio Modern", size: 18)
        self.levelLabel.text = ""
        self.view.addSubview(self.levelLabel)
        
        self.starView = UIImageView(image: UIImage(named: "starView"))
        self.starView.frame = CGRect(x: 155, y: 180, width: 40, height: 40)
        self.view.addSubview(self.starView)
        self.starView.isHidden = true
        
        
        self.playGameBtn.setImage(UIImage(named: "playGame_btn"), for: .normal)
        self.playGameBtn.frame = CGRect(x: (squareView.frame.width)/2 - 30, y: (squareView.frame.height/2) - 30, width: 60, height: 60)
        self.playGameBtn.addTarget(self, action: #selector(self.startGame), for: .touchUpInside)
        self.squareView.addSubview(self.playGameBtn)
        
        self.recordBtn.setImage(UIImage(named: "record_btn"), for: .normal)
        self.recordBtn.frame = CGRect(x: (squareView.frame.width)/2 - 30, y: (squareView.frame.height/2) - 30, width: 60, height: 60)
        self.recordBtn.addTarget(self, action: #selector(self.startOrPlayRecording), for: .touchUpInside)
        self.recordBtn.isHidden = true
        self.squareView.addSubview(self.recordBtn)
        
        self.setupAudioFiles()
        self.setupButtons()
        self.game = DoReMiFaGame(sounds: sounds, pinkBtn: self.pinkBtn, yellowBtn: self.yellowBtn, greenBtn: self.greenBtn, purpleBtn: self.purpleBtn, delegate: self)
        
        self.recorder = DoReMiFaRecorder(sounds: sounds, pinkBtn: self.pinkBtn, yellowBtn: self.yellowBtn, greenBtn: self.greenBtn, purpleBtn: self.purpleBtn, delegate: self)
        
        
    }
    
    
    @objc func buttonAction(sender: UIButton) {
        //print(self.game.getGameStatus())
        
        if doremifaMode == Mode.Freestyle {
            if self.recorder.getRecordingStatus() == RecorderStatus.Recording {
                self.sounds[sender.tag].play()
                self.recorder.savePressedColorSound(buttonPressed: sender.tag)
            } else if self.recorder.getRecordingStatus() == RecorderStatus.NotRecording {
                sounds[sender.tag].play()
            }
            
        } else {
            self.sounds[sender.tag].play()
            if (self.game.continueToCheck() == true) {
                self.game.checkPressedButton(buttonPressed: sender.tag)
            }
        }
    }
    
    @objc func changeMode() {
        self.levelLabel.text = ""
        self.starView.isHidden = true
        self.game.resetGame()
        
        self.infoLabel.isHidden = true
        self.squareView.fadeOut()
        
        self.squareView.fadeIn(completion: {
            (finished: Bool) -> Void in
            self.infoLabel.isHidden = false
            self.infoLabel.fadeIn()
        })
        
        if self.doremifaMode == Mode.GameMode {
            self.doremifaMode = Mode.Freestyle
            self.playGameBtn.isHidden = true
            self.recordBtn.isHidden = false
            self.infoLabel.text = "Create your track."
            self.modeBtn.setImage(UIImage(named: "freestyle_btn"), for: .normal)
            self.modeBtn.setImage(UIImage(named: "gameMode_btn"), for: .highlighted)
        } else {
            self.doremifaMode = Mode.GameMode
            self.playGameBtn.isHidden = false
            self.recordBtn.isHidden = true
            self.playGameBtn.setImage(UIImage(named: "playGame_btn"), for: .normal)
            self.infoLabel.text = "Can you follow my notes?"
            self.levelLabel.text = ""
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
            } catch { print(error) }
        }
        for audioPlayer in self.sounds {
            audioPlayer.delegate = self
            audioPlayer.numberOfLoops = 0
        }
    }
    
    
    @objc func startGame() {
        self.starView.layer.removeAllAnimations()
        self.starView.isHidden = true
        
        self.game.resetGame()
        self.game.disableColorButtons()
        self.playGameBtn.isHidden = true
        self.modeBtn.isUserInteractionEnabled = false
        self.infoLabel.text = "Get ready!"
        self.infoLabel.blink(stopAfter: 1.2)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.game.startNewLevel()
        }
    }
    
    
    @objc func startOrPlayRecording() {
        self.modeBtn.isUserInteractionEnabled = false
        if recorder.getRecordingStatus() == RecorderStatus.NotRecording {
            self.sounds[6].play()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                self.recorder.startRecording()
                self.infoLabel.text = "Recording.."
                self.infoLabel.blink()
                self.recordBtn.isHidden = true
            }
        }
        if recorder.getRecordingStatus() == RecorderStatus.ReadyToPlay {
            //play the first item
            self.recorder.playNextItem()
            self.recordBtn.isHidden = true
        }
    }
    
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if game.getGameStatus() == GameStatus.SequencePlaying {
            self.game.afterSoundIsPlayed()
        }
        //print(game.getGameStatus())
        if game.getGameStatus() == GameStatus.UserPlaying {
            self.infoLabel.text = "Your turn."
        }
        
        //print(recorder.getRecordingStatus())
        if recorder.getRecordingStatus() == RecorderStatus.PlayingSavedSequence {
            self.recorder.playTheSequence()
        }
    }
    
    //DoReMiFaGameDelegate implementation
    public func gameOver() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.sounds[5].play()
        }
        self.infoLabel.text = "Opps.. Game Over!"
        self.infoLabel.blink()
        self.playGameBtn.setImage(UIImage(named: "replay_btn"), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.squareView.fadeOut()
            self.infoLabel.text = ""
            self.infoLabel.blink(enabled: false)
            self.squareView.fadeIn(completion: {
                (finished: Bool) -> Void in
                self.infoLabel.text = "You can always try again!"
                self.infoLabel.fadeIn(completion: {
                    (finished: Bool) -> Void in
                    self.playGameBtn.isHidden = false
                })
            })
        }
        self.modeBtn.isUserInteractionEnabled = true
    }
    
    
    public func newLevel() {
        self.infoLabel.text = ""
        self.levelLabel.text = "Level:  \(self.game.getCurrentLevel())"
    }
    
    public func userWonTheGame() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.sounds[4].play()
            self.starView.isHidden = false
            self.starView.zoomInOut()
            self.starView.rotate()
        }
        self.infoLabel.text = "Congratulations!"
        self.infoLabel.blink()
        self.playGameBtn.setImage(UIImage(named: "replay_btn"), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.squareView.fadeOut()
            self.infoLabel.text = ""
            self.infoLabel.blink(enabled: false)
            self.squareView.fadeIn(completion: {
                (finished: Bool) -> Void in
                self.infoLabel.text = "Congrats, play again!"
                self.infoLabel.fadeIn(completion: {
                    (finished: Bool) -> Void in
                    self.playGameBtn.isHidden = false
                })
            })
        }
        self.modeBtn.isUserInteractionEnabled = true
    }
    
    
    //DoReMiFaRecorderDelegate implementation
    public func isTimeToPlay() {
        self.recordBtn.setImage(UIImage(named: "playRecorded_btn"), for: .normal)
        self.recordBtn.isHidden = false
        self.infoLabel.blink(enabled: false)
        self.infoLabel.text = "Listen to your recording!"
    }
    
    public func sequenceDidFinishPlaying() {
        self.recordBtn.setImage(UIImage(named: "record_btn"), for: .normal)
        self.infoLabel.text = "Record a new audio."
        self.recordBtn.isHidden = false
        self.modeBtn.isUserInteractionEnabled = true
    }
    
    
}

