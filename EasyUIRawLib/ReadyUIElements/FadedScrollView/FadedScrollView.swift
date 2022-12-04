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
    private var bottomFadeView: UIView?
    
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
        configureTopFadeView()
        configureBottomFadeView()
        
        
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
    
    private func configureTopFadeView() {
        topFadeView = UIView()
        topFadeView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topFadeView!)
        topFadeView!.heightAnchor.constraint(equalTo: heightAnchor, multiplier: topFadeSizeMult).isActive = true
        topFadeView!.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        topFadeView!.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        topFadeView!.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        topFadeView?.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        
//        DispatchQueue.main.async {
//            self.topGradientMask = self.topFadeView!.addGradientLayer(color1: UIColor.white.withAlphaComponent(0.0), color2: UIColor.white.withAlphaComponent(1.0))
//            //self.layer.mask = self.topGradientMask!
//            self.mask = self.topFadeView!
//        }
        
        //layer.mask = topGradientMask
        
    }
    
    private func configureBottomFadeView() {
        bottomFadeView = UIView()
        bottomFadeView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomFadeView!)
        bottomFadeView!.heightAnchor.constraint(equalTo: heightAnchor, multiplier: topFadeSizeMult).isActive = true
        bottomFadeView!.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        bottomFadeView!.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomFadeView!.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        bottomFadeView?.backgroundColor = UIColor.red.withAlphaComponent(0.5)
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
