//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    let squareView = UIView()
    
    override func loadView() {
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 20, width: 200, height: 20)
        label.text = "Hello World!"
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
            print("pink")
        case 1:
            print("yellow")
        case 2:
            print("green")
        case 3:
            print("purple")
        default:
            print("Something went wrong 🤔")
        }
    }
    
    
    func setupButtons() {
        
        //Pink button
        let pinkBtn = UIButton()
        pinkBtn.setImage(UIImage(named: "pink_btn"), for: .normal)
        pinkBtn.setImage(UIImage(named: "pink_btn_on"), for: .highlighted)
        pinkBtn.frame = CGRect(x: (squareView.frame.width)/2 - 30, y: 0, width: 60, height: 60)
        pinkBtn.tag = 0
        pinkBtn.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        
        
        squareView.addSubview(pinkBtn)
        
        //Yellow button
        let yellowBtn = UIButton()
        yellowBtn.setImage(UIImage(named: "yellow_btn"), for: .normal)
        yellowBtn.setImage(UIImage(named: "yellow_btn_on"), for: .highlighted)
        yellowBtn.frame = CGRect(x: (squareView.frame.width)/2 - 30, y: squareView.frame.height - 60 , width: 60, height: 60)
        yellowBtn.tag = 1
        yellowBtn.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        squareView.addSubview(yellowBtn)
        
        //Green button
        let greenBtn = UIButton()
        greenBtn.setImage(UIImage(named: "green_btn"), for: .normal)
        greenBtn.setImage(UIImage(named: "green_btn_on"), for: .highlighted)
        greenBtn.frame = CGRect(x: 0, y: (squareView.frame.height/2) - 30 , width: 60, height: 60)
        greenBtn.tag = 2
        greenBtn.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        squareView.addSubview(greenBtn)
        
        //Purple button
        let purpleBtn = UIButton()
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
