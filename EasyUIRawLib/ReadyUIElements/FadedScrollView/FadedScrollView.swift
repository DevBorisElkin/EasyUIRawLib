//
//  FadedScrollView.swift
//  EasyUIRawLib
//
//  Created by test on 04.12.2022.
//

import UIKit

class FadedScrollView: UIScrollView {
    @IBInspectable var enableTopFade: Bool = false
    @IBInspectable var enableBottomFade: Bool = false
    
    @IBInspectable var topFadeSizeMult: CGFloat = 0.1
    @IBInspectable var bottomFadeSizeMult: CGFloat = 0.1
    
    // internal items
    private var topGradientMask: CAGradientLayer?
    private var bottomGradientMask: CAGradientLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        if enableTopFade {
            topGradientMask = addGradientLayer(color1: UIColor.white.withAlphaComponent(0.0), color2: UIColor.white.withAlphaComponent(1.0))
            layer.mask = topGradientMask
        }
        
        if enableBottomFade {
            bottomGradientMask = addGradientLayer(color1: UIColor.white.withAlphaComponent(1.0), color2: UIColor.white.withAlphaComponent(0.0))
            layer.mask = bottomGradientMask
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topGradientMask?.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height * topFadeSizeMult)
        let bottomLayerHeight: CGFloat = bounds.height * topFadeSizeMult
        bottomGradientMask?.frame = CGRect(x: 0, y: bounds.height - bottomLayerHeight, width: bounds.width, height: bottomLayerHeight)
    }
}
