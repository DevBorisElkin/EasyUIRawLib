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
    
    var layerGradient: CAGradientLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override var contentOffset: CGPoint {
        didSet {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layerGradient?.frame = safeAreaLayoutGuide.layoutFrame
            CATransaction.commit()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        configureFadeLayer()
    }
    
    private func configureFadeLayer() {
        
        let transparentColor = UIColor.white.withAlphaComponent(0).cgColor
        let opaqueColor = UIColor.white.cgColor
        
        let layerGradient = CAGradientLayer()
        self.layerGradient = layerGradient
        
        layerGradient.colors = [transparentColor, opaqueColor, opaqueColor, transparentColor]
        
        layerGradient.frame = bounds
        layerGradient.startPoint = CGPoint(x: 0, y: 0)
        layerGradient.endPoint = CGPoint(x: 0, y: 1)
        
        layerGradient.locations = [0, 0.1, 0.9, 1.0]
        
        layer.addSublayer(layerGradient)
        layer.mask = layerGradient
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
