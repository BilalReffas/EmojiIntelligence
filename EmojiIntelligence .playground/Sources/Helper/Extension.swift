import UIKit
import AudioToolbox

public extension UIView {
    func fadeIn(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeOut(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration,
                       animations: {
            self.alpha = 0.0
        })
    }
    func transformAnimation() {
        UIView.animate(withDuration: 0.6, animations: {
            self.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
        }, completion: { (finish) in
            UIView.animate(withDuration: 0.6,
                           animations: {
                self.transform = CGAffineTransform.identity
            })
        })
    }

}

public extension SystemSoundID {
    static func playFileNamed(fileName: String, withExtenstion fileExtension: String) {
        var sound: SystemSoundID = 0
        if let soundURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &sound)
            AudioServicesPlaySystemSound(sound)
        }
    }
}

public extension UILabel {
    
    func startBlink() {
        UIView.animate(withDuration: 0.8,
                       delay:0.0,
                       options:[.autoreverse, .repeat],
                       animations: {
                        self.alpha = 0
        }, completion: nil)
    }
    
    func stopBlink() {
        alpha = 1
        layer.removeAllAnimations()
    }
}
public extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
}
