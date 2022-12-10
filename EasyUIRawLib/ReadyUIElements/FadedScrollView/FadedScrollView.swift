//
//  FadedScrollView.swift
//  EasyUIRawLib
//
//  Created by test on 04.12.2022.
//

import UIKit

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
    @IBInspectable var startProgressToFullFade: Int = 10 {
        didSet { startProgressToFullFadeMult = CGFloat(startProgressToFullFade) / 100 }
    }
    @IBInspectable var endProgressToFullFade: Int = 10 {
        didSet { endProgressToFullFadeMult = CGFloat(endProgressToFullFade) / 100 }
    }
    
    /// min is 2. preferred max is 10, the smaller the value, the steeper the transition
    @IBInspectable var logarithmicBase: Double = 2
    @IBInspectable var linearInterpolation: Bool = true
    // further away from top/bottom borders - disappearing of content slows down
    @IBInspectable var logarithmicFromEdges: Bool = false
    // further away from top/bottom borders - disappearing of content speeds up
    @IBInspectable var exponentialFromEdges: Bool = false
    
    private var interpolation: FadeInterpolation?
    
    var fadeInterpolation: EasyUICalculationHelpers.Interpolation = .linear
    
    var startFadeSizeMult: CGFloat = 0.1
    var endFadeSizeMult: CGFloat = 0.1
    var startProgressToFullFadeMult: CGFloat = 0.10
    var endProgressToFullFadeMult: CGFloat = 0.10
    
    @IBInspectable var debugModeEnabled: Bool = false
    @IBInspectable var progressLogs: Bool = false
    // Internal items
    
    var layerGradient: CAGradientLayer?
    
    private let transparentColor = UIColor.white.withAlphaComponent(0)
    private lazy var cgTransparentColor = transparentColor.cgColor
    private let opaqueColor = UIColor.white
    private lazy var cgOpaqueColor = opaqueColor.cgColor
    
    var progressManager: ProgressManager!
    
    private var internalEnabledCheck: Bool {
        enableStartFade || enableEndFade
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
    
    func configureLogarithmic(startFadeSize: CGFloat, endFadeSize: CGFloat) {
        
    }
    
    func configure(isVertical: Bool, enableStartFade: Bool, enableEndFade: Bool, startFadeSizeMult: CGFloat, endFadeSizeMult: CGFloat, startProgressToFullFadeMult: CGFloat, endProgressToFullFadeMult: CGFloat, interpolation: FadeInterpolation, logarithmicBase: Double) {
        self.isVertical = isVertical
        self.enableStartFade = enableStartFade
        self.enableEndFade = enableEndFade
        self.startFadeSizeMult = startFadeSizeMult
        self.endFadeSizeMult = endFadeSizeMult
        self.startProgressToFullFadeMult = startProgressToFullFadeMult
        self.endProgressToFullFadeMult = endProgressToFullFadeMult
        self.interpolation = interpolation
        self.logarithmicBase = logarithmicBase
        commonInit()
    }
    
    // todo
    func switchFadesEnabled(_ enabled: Bool) {
        switchStartFadeEnabled(enabled)
        switchEndFadeEnabled(enabled)
    }
    func switchStartFadeEnabled(_ enabled: Bool){
        
    }
    func switchEndFadeEnabled(_ enabled: Bool){
        
    }
    
    private func commonInit() {
        log("FadedScrollView.CommonInit() / isVertical: \(isVertical)")
        guard internalEnabledCheck else { return }
        
        progressManager = isVertical ? VerticalProgressManager(debugModeEnabled: debugModeEnabled) : HorizontalProgressManager(debugModeEnabled: debugModeEnabled)
        progressManager.configure(parentScrollView: self, startFadeSizeMult: startProgressToFullFadeMult, endFadeSizeMult: endProgressToFullFadeMult)
        
        configureFadeLayer()
        configureFadeInterpolation(injectedFromCode: interpolation)
    }
    
    private func configureFadeLayer() {
        let layerGradient = CAGradientLayer()
        self.layerGradient = layerGradient
        
        let firstColor = enableStartFade ? cgTransparentColor : cgOpaqueColor
        let lastColor = enableEndFade ? cgTransparentColor : cgOpaqueColor
        layerGradient.colors = [firstColor, cgOpaqueColor, cgOpaqueColor, lastColor]
        
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
    
    private func configureFadeInterpolation(injectedFromCode: FadeInterpolation?) {
        if let injectedFromCode = injectedFromCode {
            self.fadeInterpolation = injectedFromCode == .linear ? .linear : injectedFromCode == .logarithmicFromEdges ? .exponentioal : .linear
        } else {
            if !linearInterpolation && !logarithmicFromEdges && !exponentialFromEdges {
                self.fadeInterpolation = .linear
            } else {
                self.fadeInterpolation = linearInterpolation ? .linear : logarithmicFromEdges ? .exponentioal : .logarithmic
            }
        }
    }
    
    // MARK: Mange gradient colors on scroll
    // todo
    private func manageGradientColorsOnScroll() {
        log("manageGradientColorsOnScroll, isVertical: \(isVertical)")
        if var colors = layerGradient?.colors as? [CGColor] {
            let progress = progressManager.calculateProgress()
            let startAbsProgress = progressManager.calculateStartFadeProgress()
            let endAbsProgress = progressManager.calculateEndFadeProgress()
            let startTransformedProgress = EasyUICalculationHelpers.logarythmicBasedDependence(progress: startAbsProgress, base: logarithmicBase, interpolation: fadeInterpolation)
            let endTransformedProgress = EasyUICalculationHelpers.logarythmicBasedDependence(progress: endAbsProgress, base: logarithmicBase, interpolation: fadeInterpolation)
            
            progressLog("progress: \(progress)")
            progressLog("startAbsProgress: \(startAbsProgress), endAbsProgress: \(endAbsProgress)")
            progressLog("startTransformedProgress: \(startTransformedProgress), endTransformedProgress: \(endTransformedProgress)")
            
            if enableStartFade {
                colors[0] = opaqueColor.withAlphaComponent(startTransformedProgress).cgColor
            }
            if enableEndFade {
                colors[3] = opaqueColor.withAlphaComponent(endTransformedProgress).cgColor
            }
            
            layerGradient?.colors = colors
        }
    }
    
    enum FadeInterpolation {
        case linear, logarithmicFromEdges, exponentialFromEdges
    }
    
    private func log(_ message: String) {
        guard debugModeEnabled else { return }
        print(message)
    }
    private func progressLog(_ message: String) {
        guard progressLogs else { return }
        print(message)
    }
    
    open class ProgressManager {
        internal weak var parentScrollView: UIScrollView!
        internal var startFadeSizeMult: CGFloat = 0
        internal var endFadeSizeMult: CGFloat = 0
        internal var debugModeEnabled: Bool
        
        init(debugModeEnabled: Bool) {
            self.debugModeEnabled = debugModeEnabled
        }
        
        // for debugging only
        func calculateProgress() -> CGFloat {
            let maxHeightForProgress = contentSize() - scrollViewSize()
            return max(min(contentOffset() / maxHeightForProgress, 1), 0)
        }
        // deprecated
        func calculateStartAlpha(progress: CGFloat) -> CGFloat {
            if progress > startFadeSizeMult { return 0 }
            return CGFloat(1) - progress / startFadeSizeMult
        }
        // deprecated
        func calculateEndAlpha(progress: CGFloat) -> CGFloat {
            let progressMargin = CGFloat(1) - endFadeSizeMult
            if progress < progressMargin { return 0 }
            return (progress - progressMargin) / endFadeSizeMult
        }
        
        func scrollViewSize() -> CGFloat { print("Internal Error! Base class ProgressManager method is being called!"); return 0 }
        func contentSize() -> CGFloat { print("Internal Error! Base class ProgressManager method is being called!"); return 0 }
        func contentOffset() -> CGFloat { print("Internal Error! Base class ProgressManager method is being called!"); return 0 }
        func effectiveContentOffset() -> CGFloat {
            return contentOffset() + scrollViewSize()
        }
        
        func calculateStartFadeProgress() -> CGFloat {
            let maxProgress = scrollViewSize() * startFadeSizeMult
            if contentOffset() > maxProgress { return 0 }
            
            return min(1 - (contentOffset() / maxProgress), 1)
        }
        func calculateEndFadeProgress() -> CGFloat {
            let scrolledFromEnd = contentSize() - effectiveContentOffset()
            let maxProgress = scrollViewSize() * startFadeSizeMult
            if scrolledFromEnd > maxProgress { return 0 }
            return min(1 - scrolledFromEnd / maxProgress, 1)
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
        
        override func scrollViewSize() -> CGFloat {
            parentScrollView.bounds.height
        }
        override func contentSize() -> CGFloat {
            parentScrollView.contentSize.height
        }
        override func contentOffset() -> CGFloat {
            parentScrollView.contentOffset.y
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
        
        override func scrollViewSize() -> CGFloat {
            parentScrollView.bounds.width
        }
        override func contentSize() -> CGFloat {
            parentScrollView.contentSize.width
        }
        override func contentOffset() -> CGFloat {
            parentScrollView.contentOffset.x
        }
    }
}
