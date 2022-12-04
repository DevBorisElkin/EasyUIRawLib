//
//  FadedScrollView.swift
//  EasyUIRawLib
//
//  Created by test on 04.12.2022.
//

import UIKit

// todo make ability to set values via code
// todo make ability to configure/disable fade if needed
open class FadedScrollView: UIScrollView {
    @IBInspectable var isVertical: Bool = true
    
    @IBInspectable var enableStartFade: Bool = true
    @IBInspectable var enableEndFade: Bool = true
    
    @IBInspectable var startFadeSize: Int = 10 {
        didSet { startFadeSizeMult = CGFloat(startFadeSize) / 100 }
    }
    @IBInspectable var endFadeSize: Int = 10 {
        didSet { endFadeSizeMult = CGFloat(endFadeSize) / 100 }
    }
    
    var startFadeSizeMult: CGFloat = 0.1
    var endFadeSizeMult: CGFloat = 0.1
    
    @IBInspectable var debugModeEnabled: Bool = false
    
    // Internal items
    
    var layerGradient: CAGradientLayer?
    
    private let transparentColor = UIColor.white.withAlphaComponent(0)
    private lazy var cgTransparentColor = transparentColor.cgColor
    private let opaqueColor = UIColor.white
    private lazy var cgOpaqueColor = opaqueColor.cgColor
    
    var progressManager: ProgressManager!
    
    private var internalEnabledCheck: Bool {
        let isEnabled = enableStartFade || enableEndFade
        if !isEnabled { print("FadedScrollView Error, both fades disabled, consider replacing it to general scroll view!") }
        return isEnabled
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    open override var contentOffset: CGPoint {
        didSet {
            guard internalEnabledCheck else { return }
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layerGradient?.frame = safeAreaLayoutGuide.layoutFrame
            CATransaction.commit()
            manageGradientColorsOnScroll()
        }
    }
    
    private func commonInit() {
        log("FadedScrollView.CommonInit() / isVertical: \(isVertical)")
        guard internalEnabledCheck else { return }
        
        progressManager = isVertical ? VerticalProgressManager(debugModeEnabled: debugModeEnabled) : HorizontalProgressManager(debugModeEnabled: debugModeEnabled)
        progressManager.configure(parentScrollView: self, startFadeSizeMult: startFadeSizeMult, endFadeSizeMult: endFadeSizeMult)
        configureFadeLayer()
    }
    
    private func configureFadeLayer() {
        let layerGradient = CAGradientLayer()
        self.layerGradient = layerGradient
        
        layerGradient.colors = [cgTransparentColor, cgOpaqueColor, cgOpaqueColor, cgTransparentColor]
        
        layerGradient.frame = bounds
        if isVertical {
            layerGradient.startPoint = CGPoint(x: 0, y: 0)
            layerGradient.endPoint = CGPoint(x: 0, y: 1)
        } else {
            layerGradient.startPoint = CGPoint(x: 0, y: 0)
            layerGradient.endPoint = CGPoint(x: 1, y: 0)
        }
        
        layerGradient.locations = [0, startFadeSizeMult as NSNumber, (1.0 - endFadeSizeMult) as NSNumber, 1.0]
        
        layer.addSublayer(layerGradient)
        if !debugModeEnabled {
            layer.mask = layerGradient
        }
        
        // first internal call
        manageGradientColorsOnScroll()
    }
    
//    open override func layoutSubviews() {
//        super.layoutSubviews()
//    }
    
    // MARK: Mange gradient colors on scroll
    // todo
    private func manageGradientColorsOnScroll() {
        log("manageGradientColorsOnScroll, isVertical: \(isVertical)")
        if var colors = layerGradient?.colors as? [CGColor] {
            let progress = progressManager.calculateProgress()
            let startAbsProgress = progressManager.calculateStartAlpha(progress: progress)
            let endAbsProgress = progressManager.calculateEndAlpha(progress: progress)
            
            print("progress: \(progress)")
            print("startAbsProgress: \(startAbsProgress), endAbsProgress: \(endAbsProgress)")
            
            if enableStartFade {
                colors[0] = opaqueColor.withAlphaComponent(startAbsProgress).cgColor
            }
            if enableEndFade {
                colors[3] = opaqueColor.withAlphaComponent(endAbsProgress).cgColor
            }
            
            layerGradient?.colors = colors
        }
    }
    
    private func log(_ message: String) {
        guard debugModeEnabled else { return }
        print(message)
    }
    
    open class ProgressManager {
        internal weak var parentScrollView: UIScrollView?
        internal var startFadeSizeMult: CGFloat = 0
        internal var endFadeSizeMult: CGFloat = 0
        internal var debugModeEnabled: Bool
        
        init(debugModeEnabled: Bool) {
            self.debugModeEnabled = debugModeEnabled
        }
        
        func calculateProgress() -> CGFloat { print("Internal Error! Base class ProgressManager method is being called!"); return 0 }
        func calculateStartAlpha(progress: CGFloat) -> CGFloat {
            if progress > startFadeSizeMult { return 0 }
            return CGFloat(1) - progress / startFadeSizeMult
        }
        func calculateEndAlpha(progress: CGFloat) -> CGFloat {
            let progressMargin = CGFloat(1) - endFadeSizeMult
            if progress < progressMargin { return 0 }
            return (progress - progressMargin) / endFadeSizeMult
        }
        
        func configure(parentScrollView: UIScrollView?, startFadeSizeMult: CGFloat, endFadeSizeMult: CGFloat) {
            self.parentScrollView = parentScrollView
            self.startFadeSizeMult = startFadeSizeMult
            self.endFadeSizeMult = endFadeSizeMult
        }
        
        internal func log(_ message: String) {
            guard debugModeEnabled else { return }
            print(message)
        }
    }
    
    class VerticalProgressManager: ProgressManager {
        override init(debugModeEnabled: Bool) {
            super.init(debugModeEnabled: debugModeEnabled)
            log("VerticalProgressManager created")
        }
        override func calculateProgress() -> CGFloat {
            guard let parentScrollView = parentScrollView else { print("Internal error! ScrollView not assigned."); return 0 }
            let contentSize = parentScrollView.contentSize.height
            let contentOffset = parentScrollView.contentOffset.y
            let maxHeightForProgress = contentSize - parentScrollView.bounds.height
            return max(min(contentOffset / maxHeightForProgress, 1), 0)
        }
    }
    
    class HorizontalProgressManager: ProgressManager {
        override init(debugModeEnabled: Bool) {
            super.init(debugModeEnabled: debugModeEnabled)
            log("HorizontalProgressManager created")
        }
        override func calculateProgress() -> CGFloat {
            guard let parentScrollView = parentScrollView else { print("Internal error! ScrollView not assigned."); return 0 }
            let contentSize = parentScrollView.contentSize.width
            let contentOffset = parentScrollView.contentOffset.x
            log("contentSize: \(contentSize), contentOffset: \(contentOffset)")
            let maxWidthForProgress = contentSize - parentScrollView.bounds.width
            return max(min(contentOffset / maxWidthForProgress, 1), 0)
        }
    }
}
