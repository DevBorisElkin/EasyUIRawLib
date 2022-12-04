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
    
    private var topFadeView: UIView?
    
    private var topGradientMask: CAGradientLayer?
    private var bottomGradientMask: CAGradientLayer?
    
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
        
        topFadeView = UIView()
        topFadeView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topFadeView!)
        topFadeView!.heightAnchor.constraint(equalTo: heightAnchor, multiplier: topFadeSizeMult).isActive = true
        topFadeView!.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        topFadeView!.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        topFadeView!.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        topFadeView?.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        
//        DispatchQueue.main.async {
//            if self.enableTopFade {
//                self.topGradientMask = self.addGradientLayer(color1: UIColor.white.withAlphaComponent(0.0), color2: UIColor.white.withAlphaComponent(1.0))
//                //layer.mask = topGradientMask
//            }
            
//            if self.enableBottomFade {
//                self.bottomGradientMask = self.addGradientLayer(color1: UIColor.white.withAlphaComponent(1.0), color2: UIColor.white.withAlphaComponent(0.0))
//                //layer.mask = bottomGradientMask
//            }
        
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
////        topGradientMask?.frame = CGRect(x: 0, y: contentOffset.y, width: bounds.width, height: bounds.height * topFadeSizeMult)
//        //layoutSubviews()
////        let bottomLayerHeight: CGFloat = bounds.height * topFadeSizeMult
//        //bottomGradientMask?.frame = CGRect(x: 0, y: bounds.height - bottomLayerHeight, width: bounds.width, height: bottomLayerHeight)
//        //super.layoutSubviews()
//    }
    
    
}

//extension FadedScrollView: UIScrollViewDelegate {
////    func scrollViewDidScroll(_ scrollView: UIScrollView) {
////        topGradientMask?.frame = CGRect(x: 0, y: contentOffset.y, width: bounds.width, height: bounds.height * topFadeSizeMult)
////    }
//}
