import Foundation
import AVFoundation
import UIKit

public protocol DoReMiFaRecorderDelegate {
    func isTimeToPlay()
    func sequenceDidFinishPlaying()
}

public class DoReMiFaRecorder {
    //save the sound sequence to be played
    var recordedSequence = [Int]()
    
    var currentItem = 0
    let defaultMax = 5

    var recorderStatus = RecorderStatus.NotRecording

    var sounds : [AVAudioPlayer]
    
    //colored buttons
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
        self.enableColorButtons()
        self.recordedSequence = []
        print("Sound Sequence recorded:",recordedSequence)
        self.recorderStatus = RecorderStatus.Recording
        print(self.getRecordingStatus())
    }

    public func playTheSequence() {
        self.resetButtonsHighlights()
    
        if self.currentItem <= self.recordedSequence.count - 1 {
            //adding delay between the sounds
            print(currentItem)
            print("next item")

            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(30)) {
                self.playNextItem()
            }
        } else {
            self.recorderStatus = RecorderStatus.NotRecording
            self.enableColorButtons()
            //Play saved sequence
            print("Finish playing the recorded sequence")
            self.delegate?.sequenceDidFinishPlaying()
        }
    }
    
    public func playNextItem () {
        let playedSound = recordedSequence[currentItem]
        print("played sound :", playedSound)
        
        self.disableColorButtons()
        self.recorderStatus = RecorderStatus.PlayingSavedSequence
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
        print("button pressed:", buttonPressed)
        print("seq count", self.recordedSequence.count)
        
        if self.recordedSequence.count == self.defaultMax {
            print("time to play")
            
            self.recorderStatus = RecorderStatus.ReadyToPlay
            self.delegate?.isTimeToPlay()
            self.disableColorButtons()
            //delay for the next level
        } else if self.recordedSequence.count < self.defaultMax {
            self.recordedSequence.append(buttonPressed)
            print(recordedSequence)
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

