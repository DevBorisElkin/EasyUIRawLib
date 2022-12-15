//
//  ClickAnimatedButton.swift
//  EasyUIRawLib
//
//  Created by Boris Elkin on 15.12.2022.
//

import UIKit

class ClickAnimatedButton: UIButton {
    
    @IBInspectable var animationTime: Int = 10
    @IBInspectable var minScale: Int = 97
    @IBInspectable var normalScale: Int = 100
    
    var internalAnimationTime: Double = 0.1
    var internalMinScale: CGFloat = 0.97
    var internalNormalScale: CGFloat = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addTarget(self, action: #selector(buttonTouchedDown), for: .touchDown)
        addTarget(self, action: #selector(buttonTouchedUp), for: .touchUpInside)
        addTarget(self, action: #selector(buttonTouchedUp), for: .touchCancel)
        addTarget(self, action: #selector(buttonTouchedUp), for: .touchDragExit)
    }
    
    override func awakeFromNib() {
        internalAnimationTime = Double(animationTime) / 100
        internalMinScale = CGFloat(minScale) / 100
        internalNormalScale = CGFloat(normalScale) / 100
    }
    
    func configure(animationTime: Double = 0.1, minScale: CGFloat = 0.97){
        self.internalAnimationTime = animationTime
        self.internalMinScale = minScale
    }
    
    @objc private func buttonTouchedDown(_ sender: Any?){
        UIView.animate(withDuration: self.internalAnimationTime) { [weak self] in
            if let self = self {
                self.transform = CGAffineTransform(scaleX: self.internalMinScale, y: self.internalMinScale)
            }
        }
    }
    @objc private func buttonTouchedUp(_ sender: Any?){
        UIView.animate(withDuration: self.internalAnimationTime) { [weak self] in
            if let self = self {
                self.transform = CGAffineTransform(scaleX: self.internalNormalScale, y: self.internalNormalScale)
            }
        }
    }
}
