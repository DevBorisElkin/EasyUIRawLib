//
//  FadedScrollView.swift
//  EasyUIRawLib
//
//  Created by test on 04.12.2022.
//

import UIKit

class FadedScrollView: UIScrollView {
    @IBInspectable var isVertical: Bool = true
    
    @IBInspectable var enableTopFade: Bool = false
    @IBInspectable var enableBottomFade: Bool = false
    
    @IBInspectable var topFadeSizeMult: CGFloat = 0.1
    @IBInspectable var bottomFadeSizeMult: CGFloat = 0.1
    
    // internal items
    
    var layerGradient: CAGradientLayer?
    
    private let transparentColor = UIColor.white.withAlphaComponent(0)
    private lazy var cgTransparentColor = transparentColor.cgColor
    private let opaqueColor = UIColor.white
    private lazy var cgOpaqueColor = opaqueColor.cgColor
    
    var progressManager: ProgressManager!
    
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
            manageGradientColorsOnScroll()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        progressManager = isVertical == true ? VerticalProgressManager() : HorizontalProgressManager()
        progressManager.configure(parentScrollView: self, startFadeSizeMult: topFadeSizeMult, endFadeSizeMult: bottomFadeSizeMult)
        configureFadeLayer()
    }
    
    private func configureFadeLayer() {
        let layerGradient = CAGradientLayer()
        self.layerGradient = layerGradient
        
        layerGradient.colors = [cgTransparentColor, cgOpaqueColor, cgOpaqueColor, cgTransparentColor]
        
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
    
    // MARK: Mange gradient colors on scroll
    // todo
    private func manageGradientColorsOnScroll() {
        
        if var colors = layerGradient?.colors as? [CGColor] {
            let progress = progressManager.calculateProgress()
            let startAbsProgress = progressManager.calculateStartAlpha(progress: progress)
            let endAbsProgress = progressManager.calculateEndAlpha(progress: progress)
            
            print("progress: \(progress)")
            print("startAbsProgress: \(startAbsProgress), endAbsProgress: \(endAbsProgress)")
            
            
            colors[0] = opaqueColor.withAlphaComponent(startAbsProgress).cgColor
            colors[3] = opaqueColor.withAlphaComponent(endAbsProgress).cgColor
            
            layerGradient?.colors = colors
        }
        
//        var finalColors: [CGColor] = [opaqueColor, opaqueColor]
//        if enableTopFade {
//            finalColors.insert(transparentColor, at: 0)
//        }
//
//        if enableBottomFade {
//
//        }
    }
    
    private func calculateProgress() -> CGFloat {
        return contentOffset.y / contentSize.height
    }
    
    private func calculateAlphaFromProgress() {
        
    }
    
    class ProgressManager {
        weak var parentScrollView: UIScrollView?
        var startFadeSizeMult: CGFloat = 0
        var endFadeSizeMult: CGFloat = 0 // 0.1 of scroll view height
        
        func calculateProgress() -> CGFloat { 0 }
        func calculateStartAlpha(progress: CGFloat) -> CGFloat { 0 }
        func calculateEndAlpha(progress: CGFloat) -> CGFloat { 0 }
        
        func configure(parentScrollView: UIScrollView?, startFadeSizeMult: CGFloat, endFadeSizeMult: CGFloat) {
            self.parentScrollView = parentScrollView
            self.startFadeSizeMult = startFadeSizeMult
            self.endFadeSizeMult = endFadeSizeMult
        }
    }
    
    class VerticalProgressManager: ProgressManager {
        override func calculateProgress() -> CGFloat {
            guard let parentScrollView = parentScrollView else { return 0 }
            let contentHeight = parentScrollView.contentSize.height
            let contentOffset = parentScrollView.contentOffset.y
            
            let maxHeightForProgress = contentHeight - parentScrollView.bounds.height
            return max(min(contentOffset / maxHeightForProgress, 1), 0)
        }
        
        override func calculateStartAlpha(progress: CGFloat) -> CGFloat {
            if progress > startFadeSizeMult { return 0 }
            return CGFloat(1) - progress / startFadeSizeMult
        }
        override func calculateEndAlpha(progress: CGFloat) -> CGFloat {
            let progressMargin = CGFloat(1) - endFadeSizeMult // 0.9
            print("realSndProgress: \(progress - progressMargin)")
            if progress < progressMargin { return 0 }
            
            return (progress - progressMargin) / endFadeSizeMult
        }
    }
    
    class HorizontalProgressManager: ProgressManager {
        override func calculateProgress() -> CGFloat {
            guard let parentScrollView = parentScrollView else { return 0 }
            let contentWidth = parentScrollView.contentSize.width
            let contentOffset = parentScrollView.contentOffset.x
            return (contentOffset + parentScrollView.bounds.width) / contentWidth
        }
    }
}
