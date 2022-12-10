//
//  FadedScrollView.swift
//  EasyUIRawLib
//
//  Created by test on 04.12.2022.
//

import UIKit

open class FadedScrollView: UIScrollView {
    @IBInspectable private var isVertical: Bool = true
    
    @IBInspectable private var enableStartFade: Bool = true
    
    @IBInspectable private var enableEndFade: Bool = true
    
    @IBInspectable private var startFadeSizePercents: Int = 10 {
        didSet { startFadeSize = CGFloat(startFadeSizePercents) / 100 }
    }
    @IBInspectable private var endFadeSizePercents: Int = 10 {
        didSet { endFadeSize = CGFloat(endFadeSizePercents) / 100 }
    }
    @IBInspectable private var startProgressToHideFadePercents: Int = 10 {
        didSet { startProgressToHideFade = CGFloat(startProgressToHideFadePercents) / 100 }
    }
    @IBInspectable private var endProgressToHideFadePercents: Int = 10 {
        didSet { endProgressToHideFade = CGFloat(endProgressToHideFadePercents) / 100 }
    }
    
    /// min is 2. preferred max is 10, the smaller the value, the steeper the transition
    @IBInspectable private var logarithmicBase: Double = 2
    
    @IBInspectable private var linearInterpolation: Bool = true
    // further away from top/bottom borders - disappearing of content slows down
    @IBInspectable private var logarithmicFromEdges: Bool = false
    // further away from top/bottom borders - disappearing of content speeds up
    @IBInspectable private var exponentialFromEdges: Bool = false
    
    private var interpolation: FadeInterpolation?
    
    private var fadeInterpolation: EasyUICalculationHelpers.Interpolation = .linear
    
    private var startFadeSize: CGFloat = 0.1
    private var endFadeSize: CGFloat = 0.1
    private var startProgressToHideFade: CGFloat = 0.10
    private var endProgressToHideFade: CGFloat = 0.10
    
    @IBInspectable private var debugModeEnabled: Bool = false
    @IBInspectable private var progressLogs: Bool = false
    
    // Internal items
    private var layerGradient: CAGradientLayer?
    
    private let transparentColor = UIColor.white.withAlphaComponent(0)
    private lazy var cgTransparentColor = transparentColor.cgColor
    private let opaqueColor = UIColor.white
    private lazy var cgOpaqueColor = opaqueColor.cgColor
    
    private open progressManager: ProgressManager!
    
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
    
    func configure(startFadeSize: CGFloat, endFadeSize: CGFloat) {
        self.configure(isVertical: true, enableStartFade: true, enableEndFade: true, startFadeSizeMult: startFadeSize, endFadeSizeMult: endFadeSize, startProgressToHideFade: startFadeSize, endProgressToHideFade: endFadeSize, interpolation: .logarithmicFromEdges, logarithmicBase: 2)
    }
    
    func configure(isVertical: Bool = true, enableStartFade: Bool = true, enableEndFade: Bool = true, startFadeSizeMult: CGFloat = 0.15, endFadeSizeMult: CGFloat = 0.15, startProgressToHideFade: CGFloat = 0.15, endProgressToHideFade: CGFloat = 0.15, interpolation: FadeInterpolation = .logarithmicFromEdges, logarithmicBase: Double = 2) {
        self.isVertical = isVertical
        self.enableStartFade = enableStartFade
        self.enableEndFade = enableEndFade
        self.startFadeSize = startFadeSizeMult
        self.endFadeSize = endFadeSizeMult
        self.startProgressToHideFade = startProgressToHideFade
        self.endProgressToHideFade = endProgressToHideFade
        self.interpolation = interpolation
        self.logarithmicBase = logarithmicBase
        commonInit()
    }
    
    private func commonInit() {
        log("FadedScrollView.CommonInit() / isVertical: \(isVertical)")
        guard internalEnabledCheck else { return }
        
        progressManager = isVertical ? VerticalProgressManager(debugModeEnabled: debugModeEnabled) : HorizontalProgressManager(debugModeEnabled: debugModeEnabled)
        progressManager.configure(parentScrollView: self, startFadeSizeMult: startProgressToHideFade, endFadeSizeMult: endProgressToHideFade)
        
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
        
        layerGradient.locations = [0, startFadeSize as NSNumber, (1.0 - endFadeSize) as NSNumber, 1.0]
        
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
        
        override func scrollViewSize() -> CGFloat { parentScrollView.bounds.height }
        override func contentSize() -> CGFloat { parentScrollView.contentSize.height }
        override func contentOffset() -> CGFloat { parentScrollView.contentOffset.y }
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
        
        override func scrollViewSize() -> CGFloat { parentScrollView.bounds.width }
        override func contentSize() -> CGFloat { parentScrollView.contentSize.width }
        override func contentOffset() -> CGFloat { parentScrollView.contentOffset.x }
    }
}
