//
//  AnimatedButton.swift
//  EasyUIRawLib
//
//  Created by test on 15.12.2022.
//

import UIKit

class AnimatedButton: UIButton {
    
    private var animationTime: Double = 0.1
    private var minScale: CGFloat = 0.97
    private var normalScale: CGFloat = 1
    
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
    
    func setUp(animationTime: Double, minScale: CGFloat = 0.93){
        self.animationTime = animationTime
        self.minScale = minScale
    }
    
    @objc private func buttonTouchedDown(_ sender: Any?){
        UIView.animate(withDuration: self.animationTime) { [weak self] in
            if let self = self {
                self.transform = CGAffineTransform(scaleX: self.minScale, y: self.minScale)
            }
        }
    }
    @objc private func buttonTouchedUp(_ sender: Any?){
        UIView.animate(withDuration: self.animationTime) { [weak self] in
            if let self = self {
                self.transform = CGAffineTransform(scaleX: self.normalScale, y: self.normalScale)
            }
        }
    }
}
