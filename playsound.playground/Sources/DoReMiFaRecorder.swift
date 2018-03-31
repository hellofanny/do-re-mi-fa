import Foundation
import AVFoundation
import UIKit

public protocol DoReMiFaRecorderDelegate {
    func isTimeToPlay()
    func sequenceDidFinishPlaying()
}

public class DoReMiFaRecorder {
    //Save the sound sequence to be played
    var recordedSequence = [Int]()
    
    var currentItem = 0
    var numberOfButtonsPressed = 0
    
    //Number Max of notes that will be recorded
    let defaultMax = 8
    
    var recorderStatus = RecorderStatus.NotRecording
    
    var sounds : [AVAudioPlayer]
    
    //Colored buttons
    let pinkBtn: UIButton
    let yellowBtn: UIButton
    let greenBtn: UIButton
    let purpleBtn: UIButton
    
    let coloredButtons: [UIButton]
    
    var delegate : DoReMiFaRecorderDelegate?
    
    public init (sounds: [AVAudioPlayer], pinkBtn: UIButton, yellowBtn: UIButton, greenBtn: UIButton, purpleBtn: UIButton, delegate: DoReMiFaRecorderDelegate)
    {
        self.sounds = sounds
        self.pinkBtn = pinkBtn
        self.yellowBtn = yellowBtn
        self.greenBtn = greenBtn
        self.purpleBtn = purpleBtn
        
        self.delegate = delegate
        
        self.coloredButtons = [self.pinkBtn, self.yellowBtn, self.greenBtn, self.purpleBtn]
    }
    
    public func getRecordingStatus() -> RecorderStatus {
        return self.recorderStatus
    }
    
    public func startRecording() {
        self.currentItem = 0
        self.numberOfButtonsPressed = 0
        self.enableColorButtons()
        self.recordedSequence = []
        self.recorderStatus = RecorderStatus.Recording
        //print(self.getRecordingStatus())
    }
    
    public func playTheSequence() {
        self.resetButtonsHighlights()
        
        if self.currentItem <= self.recordedSequence.count - 1 {
            //Adding delay between the sounds
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(30)) {
                self.playNextItem()
            }
        } else {
            self.recorderStatus = RecorderStatus.NotRecording
            self.enableColorButtons()
            
            print("Finish playing the recorded sequence!")
            self.delegate?.sequenceDidFinishPlaying()
        }
    }
    
    public func playNextItem () {
        let playedSound = self.recordedSequence[self.currentItem]
        print("Played sound :", playedSound)
        
        self.recorderStatus = RecorderStatus.PlayingSavedSequence
        self.disableColorButtons()
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
    
    
    public func savePressedColorSound (buttonPressed: Int) {
        
        if numberOfButtonsPressed == self.defaultMax - 1 {
            print("Arrived at the max!")
            self.recordedSequence.append(buttonPressed)
            self.recorderStatus = RecorderStatus.ReadyToPlay
            self.delegate?.isTimeToPlay()
            self.disableColorButtons()
            
        } else if numberOfButtonsPressed < self.defaultMax {
            self.recordedSequence.append(buttonPressed)
            
        }
        
        print("Sound Sequence recorded:", self.recordedSequence)
        self.numberOfButtonsPressed += 1
        
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

