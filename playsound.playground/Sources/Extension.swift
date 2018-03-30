import Foundation
import UIKit

extension UIView {
    
    public func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.3, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    
    public func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.3, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    public func blink() {
        self.alpha = 0.0;
        UIView.animate(withDuration: 0.5,
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: { [weak self] in self?.alpha = 1.0 },
            completion: { [weak self] _ in self?.alpha = 0.0 })
    }
    
    public func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
}
