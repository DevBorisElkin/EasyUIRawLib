//
//  ClickAnimatedView.swift
//  EasyUIRawLib
//
//  Created by test on 15.12.2022.
//

import UIKit

class ClickAnimatedView:UIView, UIGestureRecognizerDelegate {
    
    @IBInspectable var corners:Bool = false
    @IBInspectable var weakScaling:Bool = false
    @IBInspectable var shouldRecognizeSimultaniously: Bool = true
    
    var userData:[String:Any]?
    
    var scaleCoef:CGFloat = 0.97
    
    public var didStartTouchCompletion:((UIView) -> Void)?
    public var didEndTouchCompletion:((UIView) -> Void)?
    
    override func awakeFromNib() {
        
        let panGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didPan(_:)))
        panGestureRecognizer.delaysTouchesBegan = false
        panGestureRecognizer.delaysTouchesEnded = false
        panGestureRecognizer.minimumPressDuration = 0
        panGestureRecognizer.delegate = self
        panGestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(panGestureRecognizer)
        
        if corners {
            layer.cornerRadius = 15
        }
        if weakScaling { scaleCoef = 0.99 }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return shouldRecognizeSimultaniously
    }
    
    @objc private func didPan(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            
            didStartTouchCompletion?(self)
            
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [self] in
                            self.transform = CGAffineTransform.init(scaleX: self.scaleCoef, y: self.scaleCoef)
            })
            
            break
        case .ended:
            
            didEndTouchCompletion?(self)
            
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                            self?.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            })
            break
        case .cancelled:
            
            UIView.animate(withDuration: 0.05,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                            self?.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            })
            break
        default:
            break
        }
    }
}
