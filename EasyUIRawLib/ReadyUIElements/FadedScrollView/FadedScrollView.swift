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
    
//    override var contentOffset: CGPoint {
//        didSet {
////            if subviews.count > 0 {
////                let a = subviews[0]
////                print("\(self.frame.origin)")
////            }
//
//            print("contentOffset.y: \(contentOffset.y)")
////            topGradientMask?.frame = CGRect(x: 0, y: contentOffset.y, width: bounds.width, height: bounds.height * topFadeSizeMult)
//        }
//    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        print("commonInit()")
        delegate = self
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

extension FadedScrollView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
//        var contentOffset = scrollView.contentOffset
//        contentOffset.y = -contentOffset.y
        layerGradient?.position = scrollView.contentOffset
        print("contentOffset: \(contentOffset)")
        CATransaction.commit()
        
        
    }
    
//    @objc private func didScroll(_ scrollView: UIScrollView) {
//        [CATransaction begin];
//        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
//        CGPoint contentOffset = scrollView.contentOffset;
//        contentOffset.y = -contentOffset.y;
//
//        self.overlayImageView.viewlayer.mask.position = contentOffset;
//        [CATransaction commit];
//
////        [CATransaction begin];
////        [CATransaction setValue:(id)kCFBooleanTrue
////                         forKey:kCATransactionDisableActions];
////        layer.content = someImageRef;
////        [CATransaction commit];
//    }
}
