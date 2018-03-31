
/*:
 ![](doremifa_logo_small.png)
 This playground uses UIKit and AVFoundation, and it haves two main funcionallities:
 - **DoReMiFa Game:** A sound memory game, the user can try to memorize the sequence and play along.
 
 - **DoReMiFa Recorder:** You can record a mini track using the available notes to listen later. 
 */

import UIKit
import AVFoundation
import PlaygroundSupport
//:Adding custom font to the project
let cfURL = Bundle.main.url(forResource: "Cardenio Modern Bold", withExtension: "ttf")! as CFURL
CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)
//Cardenio Modern Bold font](https://www.dafont.com/cardenio-modern.font) - by Nils Cordes
//: Setting the DoReMiFaViewController
let myViewController = DoReMiFaViewController()
//:Present the DoReMiFaView in the Live View window
PlaygroundPage.current.liveView = myViewController.view
