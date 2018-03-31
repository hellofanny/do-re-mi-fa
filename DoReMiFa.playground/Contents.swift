//: A UIKit based Playground for presenting user interface

import UIKit
import AVFoundation
import PlaygroundSupport

//Adding custom font to the project
let cfURL = Bundle.main.url(forResource: "Cardenio Modern Bold", withExtension: "ttf")! as CFURL
CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)

//Present the view controller in the Live View window
let myViewController = DoReMiFaViewController()
PlaygroundPage.current.liveView = myViewController.view
