//: A UIKit based Playground for presenting user interface
  
import UIKit
import AudioToolbox
import AVFoundation
import PlaygroundSupport

class MyViewController : UIViewController {
    
    let squareView = UIView()
    
    var sounds : [SystemSoundID] = [0, 1, 2, 3]
    
    var roundSounds : [SystemSoundID] = [3,0,1,2,1]
    
    let pinkBtn = UIButton()
    let yellowBtn = UIButton()
    let greenBtn = UIButton()
    let purpleBtn = UIButton()
    
    
    override func loadView() {
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        for index in 0...sounds.count-1 {
            let fileName : String = "sound\(sounds[index])"
            
            if let soundURL = Bundle.main.url(forResource: fileName, withExtension: "wav") {
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &sounds[index])
            }
        }
      
        
        
        func playSequence(index: Int){
            let shouldPlay = (index <= roundSounds.count-1)
            if shouldPlay {
                AudioServicesPlaySystemSoundWithCompletion(sounds[Int(self.roundSounds[index])], {
          
            print(self.sounds[Int(self.roundSounds[index])])
            print(self.roundSounds[index])
                    playSequence(index: index+1)
                })
            }
        }
        
        playSequence(index: 0)
        

        
        
        
        let label = UILabel()
        label.frame = CGRect(x: 150, y: 20, width: 200, height: 20)
        label.text = "Play with me!"
        label.textColor = .black
        
        view.addSubview(label)
        
      
       // squareView.backgroundColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 0.2295341258)
        squareView.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        view.addSubview(squareView)
        
        self.setupButtons()
        
        self.view = view
    }
    
    @objc func buttonAction(sender: UIButton) {
        switch (sender.tag) {
        case 0:
            print("pink", sounds[0] )
            AudioServicesPlaySystemSound(sounds[0])
        case 1:
            print("yellow", sounds[1])
            AudioServicesPlaySystemSound(sounds[1])
        case 2:
            print("green", sounds[2])
            AudioServicesPlaySystemSound(sounds[2])
        case 3:
            print("purple", sounds[3])
            AudioServicesPlaySystemSound(sounds[3])
        default:
            print("Something went wrong 🤔")
        }
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
    

}
// Present the view controller in the Live View window
let viewController = MyViewController()
viewController.preferredContentSize = CGSize(width: 400, height: 400)

PlaygroundPage.current.liveView = viewController
