//: A UIKit based Playground for presenting user interface
  
import UIKit
import AVFoundation
import PlaygroundSupport

let cfURL = Bundle.main.url(forResource: "Cardenio Modern Bold", withExtension: "ttf")! as CFURL
CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)

class MyViewController : UIViewController, AVAudioPlayerDelegate {
    
    let squareView = UIView()
    
    var doremifaMode : Mode = Mode.GameMode

    var sounds = [AVAudioPlayer]()
    let soundsNames = ["sound_pink", "sound_yellow", "sound_green", "sound_purple"]
    
    //colored buttons
    let pinkBtn = UIButton()
    let yellowBtn = UIButton()
    let greenBtn = UIButton()
    let purpleBtn = UIButton()
    
    let startGameBtn = UIButton()
    let label = UILabel()
    let modeBtn = UIButton()
    
    
    //save the sound sequence of the game
    var soundsSequence = [Int]()

    var numberOfButtonsPressed = 0
    var currentItem = 0
    var currentLevel = 1
    let defaultMaxLevel = 5

    var gameState = GameState.NotPlaying
    
    override func loadView() {
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
       
        let logoView = UIImageView(image: UIImage(named: "doremifa_logo"))
        logoView.frame = CGRect(x: 150, y: 20, width: 180, height: 77)
        view.addSubview(logoView)
        
       
modeBtn.setImage(UIImage(named: "gameMode_btn"), for: .normal)
        modeBtn.setImage(UIImage(named: "freestyle_btn"), for: .highlighted )
         self.modeBtn.frame = CGRect(x: 170, y: logoView.frame.origin.y + 85 , width: 152, height: 25)
         self.modeBtn.addTarget(self, action: #selector(changeMode), for: .touchUpInside)
        view.addSubview(modeBtn)
        
        self.label.frame = CGRect(x: 200, y: 400, width: 200, height: 20)
        self.label.textColor = .gray
        self.label.font = UIFont(name: "Cardenio Modern", size: 22)
        self.label.text = "Play with me!"
        view.addSubview(self.label)
        
        
        self.squareView.frame = CGRect(x: 150, y: 160, width: 200, height: 200)
        view.addSubview(self.squareView)
        
        self.startGameBtn.setImage(UIImage(named: "play_btn"), for: .normal)
        self.startGameBtn.frame = CGRect(x: (squareView.frame.width)/2 - 30, y: (squareView.frame.height/2) - 30, width: 60, height: 60)
        self.startGameBtn.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        squareView.addSubview(self.startGameBtn)
        
        self.setupAudioFiles()
        self.setupButtons()
        self.view = view
    }
    
    @objc func buttonAction(sender: UIButton) {
        
        if doremifaMode == Mode.Freestyle {
            sounds[sender.tag].play()
        } else {
            sounds[sender.tag].play()
            print("buttonPressed: ", sender.tag)
            checkPressedButton(buttonPressed: sender.tag)
        }
    }
    
    @objc func changeMode() {
        if doremifaMode == Mode.GameMode {
            doremifaMode = Mode.Freestyle
             self.startGameBtn.isHidden = true
            modeBtn.setImage(UIImage(named: "freestyle_btn"), for: .normal)
            modeBtn.setImage(UIImage(named: "gameMode_btn"), for: .highlighted )
        } else {
            doremifaMode = Mode.GameMode
            self.startGameBtn.isHidden = false
            modeBtn.setImage(UIImage(named: "gameMode_btn"), for: .normal)
            modeBtn.setImage(UIImage(named: "freestyle_btn"), for: .highlighted )
        }
    }
    
    
    //Colored buttons set up
    func setupButtons() {
        
        //Pink button
        pinkBtn.setImage(UIImage(named: "pink_btn"), for: .normal)
        pinkBtn.setImage(UIImage(named: "pink_btn_on"), for: .highlighted)
        pinkBtn.frame = CGRect(x: (squareView.frame.width)/2 - 30, y: 0, width: 60, height: 60)
        pinkBtn.tag = 0
        pinkBtn.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        squareView.addSubview(pinkBtn)
        
        //Yellow button
        yellowBtn.setImage(UIImage(named: "yellow_btn"), for: .normal)
        yellowBtn.setImage(UIImage(named: "yellow_btn_on"), for: .highlighted)
        yellowBtn.frame = CGRect(x: (squareView.frame.width)/2 - 30, y: squareView.frame.height - 60 , width: 60, height: 60)
        yellowBtn.tag = 1
        yellowBtn.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        squareView.addSubview(yellowBtn)
        
        //Green button
        greenBtn.setImage(UIImage(named: "green_btn"), for: .normal)
        greenBtn.setImage(UIImage(named: "green_btn_on"), for: .highlighted)
        greenBtn.frame = CGRect(x: 0, y: (squareView.frame.height/2) - 30 , width: 60, height: 60)
        greenBtn.tag = 2
        greenBtn.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        squareView.addSubview(greenBtn)
        
        //Purple button
        purpleBtn.setImage(UIImage(named: "purple_btn"), for: .normal)
        purpleBtn.setImage(UIImage(named: "purple_btn_on"), for: .highlighted)
        purpleBtn.frame = CGRect(x: (squareView.frame.width)/2 + 40 , y: (squareView.frame.height/2) - 30 , width: 60, height: 60)
        purpleBtn.tag = 3
        purpleBtn.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        squareView.addSubview(purpleBtn)
    }
    
    //Audio Files set up
    func setupAudioFiles() {
        for sound in soundsNames {
            let soundURL = Bundle.main.url(forResource: sound, withExtension: "wav")!
            do {
                try sounds.append(AVAudioPlayer(contentsOf: soundURL))
            } catch {
                 print(error)
            }
        }
        
        for audioPlayer in sounds {
            audioPlayer.delegate = self
            audioPlayer.numberOfLoops = 0
        }
    }
    

    func highlightButton(buttonTag: Int) {
        switch buttonTag {
        case 0:
            resetButtonsHighlights()
            pinkBtn.setImage(UIImage(named:"pink_btn_on"), for: .normal)
            break
        case 1:
            resetButtonsHighlights()
            yellowBtn.setImage(UIImage(named:"yellow_btn_on"), for: .normal)
            break
        case 2:
            resetButtonsHighlights()
            greenBtn.setImage(UIImage(named:"green_btn_on"), for: .normal)
            break
        case 3:
            resetButtonsHighlights()
            purpleBtn.setImage(UIImage(named:"purple_btn_on"), for: .normal)
            break
        default:
            break
        }
    }
    
    
    func resetButtonsHighlights() {

        pinkBtn.setImage(UIImage(named: "pink_btn"), for: .normal)
        yellowBtn.setImage(UIImage(named: "yellow_btn"), for: .normal)
        greenBtn.setImage(UIImage(named: "green_btn"), for: .normal)
        purpleBtn.setImage(UIImage(named: "purple_btn"), for: .normal)
    }
    
    
    func addSoundToSequence() {
        let randomNumber = Int(arc4random_uniform(4))
        soundsSequence.append(randomNumber)
    }
    
    @objc func startGame() {
        soundsSequence = []
        currentLevel = 1
        print("New level: \(currentLevel)")
        
        addSoundToSequence()
        
        self.startGameBtn.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.playNextItem()
        }
    }
    
    func startNewLevel() {
        currentLevel += 1
        print("New level: \(currentLevel)")
        currentItem = 0
        numberOfButtonsPressed = 0
        
        addSoundToSequence()
        print("Sound Sequence:",soundsSequence)
        
        playNextItem()
    }
    
    func playNextItem () {
        print("played sound :", soundsSequence[currentItem])
        
        let playedSound = soundsSequence[currentItem]
        
        resetButtonsHighlights()
        highlightButton(buttonTag: playedSound)
        sounds[playedSound].play()
        currentItem += 1
        
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //print("Player finish playing", player)
        
        if currentItem <= soundsSequence.count - 1 {
            //adding delay between the sounds
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
                self.playNextItem()
            }
            
        }else{
            //TO DO: User turn
            self.resetButtonsHighlights()
        }
    }
    
    func checkPressedButton(buttonPressed: Int) {
        
        if buttonPressed == soundsSequence[numberOfButtonsPressed] {
            
            if numberOfButtonsPressed == (defaultMaxLevel - 1) {
                print("WON THE GAME")
            } else if numberOfButtonsPressed == soundsSequence.count - 1 {
                //at the last item of the sequence
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                //delay for the next level... add animation?
                    self.startNewLevel()
                }
            }
            numberOfButtonsPressed += 1
            
        } else {
            //GAME OVER
            print("game over!")
            label.text = "GAME OVER!"
            
        }
    }
}



// Present the view controller in the Live View window
let viewController = MyViewController()
viewController.preferredContentSize = CGSize(width: 500, height: 500)

PlaygroundPage.current.liveView = viewController
