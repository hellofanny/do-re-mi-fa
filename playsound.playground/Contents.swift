//: A UIKit based Playground for presenting user interface
  
import UIKit
import AVFoundation
import PlaygroundSupport

class MyViewController : UIViewController {
    
    let squareView = UIView()

    var sounds = [AVAudioPlayer]()
    let soundsNames = ["sound_pink", "sound_yellow", "sound_green", "sound_purple"]
    
    let pinkBtn = UIButton()
    let yellowBtn = UIButton()
    let greenBtn = UIButton()
    let purpleBtn = UIButton()
    
    var soundsSequence = [Int]()
    var currentItem = 0

    var gameState = GameState.NotPlaying
    
    override func loadView() {
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
       
        
        let label = UILabel()
        label.frame = CGRect(x: 150, y: 20, width: 200, height: 20)
        label.text = "Play with me!"
        label.textColor = .black
        
        view.addSubview(label)
        
      
       // squareView.backgroundColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 0.2295341258)
        squareView.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        view.addSubview(squareView)
        
        self.setupAudioFiles()
        self.setupButtons()
        startGame()
        
        self.view = view
    }
    
    @objc func buttonAction(sender: UIButton) {
        sounds[sender.tag].play()
        print(sender.tag)
    }
    
    
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
    
    func setupAudioFiles() {
        for sound in soundsNames {
            let soundURL = Bundle.main.url(forResource: sound, withExtension: "wav")!
            do {
                try sounds.append(AVAudioPlayer(contentsOf: soundURL))
            } catch {
                 print(error)
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(audioPlayer: AVAudioPlayer, successfully flag: Bool){
        if currentItem <= soundsSequence.count - 1 {
            //play the next item
            playNextRandomSound()
            print("play next sound")
        } else {
            gameState = GameState.UserPlaying
            resetButtonsHighlights()
            print("reseting highlight")
        }
    }
    
    func playNextRandomSound() {
        let selectedItem = soundsSequence[currentItem]
        
        highlightButton(buttonTag: selectedItem)
        sounds[selectedItem].play()
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
    
    
    func resetButtonsHighlights(){
        pinkBtn.setImage(UIImage(named: "pink_btn"), for: .normal)
        yellowBtn.setImage(UIImage(named: "yellow_btn"), for: .normal)
        greenBtn.setImage(UIImage(named: "green_btn"), for: .normal)
        purpleBtn.setImage(UIImage(named: "purple_btn"), for: .normal)
    }
    
    
    func startGame() {
        let randomNumber = Int(arc4random_uniform(4))
        print("randomNumber", randomNumber)
        soundsSequence.append(randomNumber)
        playNextRandomSound()
        
    }
    

}
// Present the view controller in the Live View window
let viewController = MyViewController()
viewController.preferredContentSize = CGSize(width: 400, height: 400)

PlaygroundPage.current.liveView = viewController
