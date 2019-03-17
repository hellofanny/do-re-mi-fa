import Foundation
import UIKit

extension UIView {
    
    public func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.2, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    
    public func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.2, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    public func blink(enabled: Bool = true, duration: CFTimeInterval = 0.6, stopAfter: CFTimeInterval = 0.0 ) {
        enabled ? (UIView.animate(withDuration: duration,
                                  delay: 0.0,
                                  options: [.curveEaseInOut, .autoreverse, .repeat],
                                  animations: { [weak self] in self?.alpha = 0.0 },
                                  completion: { [weak self] _ in self?.alpha = 1.0 })) : self.layer.removeAllAnimations()
        if !stopAfter.isEqual(to: 0.0) && enabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + stopAfter) { [weak self] in
                self?.layer.removeAllAnimations()
            }
        }
    }
    
    public func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 4
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    public func zoomInOut() {
        UIView.animate(withDuration: 1,
                       delay: 0.0,
                       options: [.curveEaseInOut],
                       animations: {
                         self.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        },completion: {
            (finished: Bool) -> Void in
            self.transform = CGAffineTransform.identity
        })
    }

    
}
