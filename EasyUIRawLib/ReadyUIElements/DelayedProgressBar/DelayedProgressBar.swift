//
//  DelayedProgressBar.swift
//  EasyUIRawLib
//
//  Created by test on 20.12.2022.
//

import UIKit

// it's horizontal only
class DelayedProgressBar: UIView {
    
    private var instantProgressView: UIView!
    private var instantProgressViewWidthConstraint: NSLayoutConstraint!
    private var delayedProgressView: UIView!
    private var delayedProgressViewWidthConstraint: NSLayoutConstraint!
    
    private var selectedColorSet: ColorSet!
    private var animationTime: Double = 0.35
    private var roundedCorners: Bool!
    private var animationDelay: Double = 0
    
    private var recordedPriveousProgress: Double = 0
    private var recordedCurrentProgress: Double = 0
    
    private static let defaultColorSet = ColorSet(backgroundColor: #colorLiteral(red: 0.1549557745, green: 0.2322508395, blue: 0.328158915, alpha: 1), instantProgressColor: #colorLiteral(red: 0.4235294118, green: 0.6549019608, blue: 1, alpha: 1).withAlphaComponent(0.5), delayedProgressColor: #colorLiteral(red: 0.4235294118, green: 0.6549019608, blue: 1, alpha: 1))
    
    // todo add ability to set up via nib
    override func awakeFromNib() {}
    
    /// Configures progress bar, but visuals still should be configured and animated. It can be done via setProgressAndAnimate() or consecutive call of setProgress() and then animate()
    func configure(colorSet: ColorSet = defaultColorSet, roundedCorners: Bool = true, animationTime: Double = 0.35, animationDelay: Double = 0) {
        selectedColorSet = colorSet
        self.roundedCorners = roundedCorners
        self.animationTime = animationTime
        self.animationDelay = animationDelay
        commonInit()
    }
    /// Configures and sets progress bar visual progress, but still needs to be animated via animate()
    func configure(colorSet: ColorSet = defaultColorSet, roundedCorners: Bool = true, animationTime: Double = 0.35, animationDelay: Double = 0, previousProgress: Double, currentProgress: Double) {
        self.configure(colorSet: colorSet, roundedCorners: roundedCorners, animationTime: animationTime, animationDelay: animationDelay)
        self.setProgress(previousProgress: previousProgress, currentProgress: currentProgress)
    }
    
    ///  Instantly animates progress bar after creation
    func configureAndAnimate(colorSet: ColorSet = defaultColorSet, roundedCorners: Bool = true, animationTime: Double = 0.35, animationDelay: Double = 0, previousProgress: Double, currentProgress: Double) {
        self.configure(colorSet: colorSet, roundedCorners: roundedCorners, animationTime: animationTime, animationDelay: animationDelay)
        self.setProgressAndAnimate(previousProgress: previousProgress, currentProgress: currentProgress)
    }
    
    private func commonInit() {
        layer.masksToBounds = true
        backgroundColor = selectedColorSet.backgroundColor
        
        let instantProgressViewTuple = createAndConstraintProgressView()
        instantProgressView = instantProgressViewTuple.view
        instantProgressViewWidthConstraint = instantProgressViewTuple.widthConstraint
        instantProgressView.backgroundColor = selectedColorSet.instantProgressColor
        
        let delayedProgressViewTuple = createAndConstraintProgressView()
        delayedProgressView = delayedProgressViewTuple.view
        delayedProgressViewWidthConstraint = delayedProgressViewTuple.widthConstraint
        delayedProgressView.backgroundColor = selectedColorSet.delayedProgressColor
        
        layoutSubviews()
        if roundedCorners {
            DispatchQueue.main.async {
                self.layer.cornerRadius = self.bounds.height / 2
                self.instantProgressView.layer.cornerRadius = self.instantProgressView.bounds.height / 2
                self.delayedProgressView.layer.cornerRadius = self.delayedProgressView.bounds.height / 2
            }
        }
    }
    
    func setProgressAndAnimate(previousProgress: Double, currentProgress: Double) {
        checkProgresses([previousProgress, currentProgress])
        delayedProgressViewWidthConstraint.constant = bounds.width * CGFloat(previousProgress)
        instantProgressViewWidthConstraint.constant = bounds.width * CGFloat(currentProgress)
        layoutSubviews()
        delayedProgressViewWidthConstraint.constant = bounds.width * CGFloat(currentProgress)
        UIView.animate(withDuration: animationTime, delay: animationDelay) {
            self.layoutSubviews()
        }
    }
    
    func setProgress(previousProgress: Double, currentProgress: Double) {
        checkProgresses([previousProgress, currentProgress])
        recordedPriveousProgress = previousProgress
        recordedCurrentProgress = currentProgress
        delayedProgressViewWidthConstraint.constant = bounds.width * CGFloat(previousProgress)
        instantProgressViewWidthConstraint.constant = bounds.width * CGFloat(currentProgress)
    }
    
    func animate() {
        layoutSubviews()
        delayedProgressViewWidthConstraint.constant = bounds.width * CGFloat(recordedCurrentProgress)
        UIView.animate(withDuration: animationTime) {
            self.layoutSubviews()
        }
    }
    
    private func checkProgresses(_ progresses: [Double]) {
        for progress in progresses {
            if progress < 0 || progress > 1 {
                fatalError("Error! Progress should be within 0...1 range, but the value was (\(progress))")
            }
        }
    }
    
    private func checkProgress(_ progress: Double) {
        if progress < 0 || progress > 1 {
            fatalError("Error! Progress should be within 0...1 range, but the value was (\(progress))")
        }
    }
    
    private func createAndConstraintProgressView() -> (view: UIView, widthConstraint: NSLayoutConstraint) {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        let widthAnchor = view.widthAnchor.constraint(equalToConstant: 0)
        widthAnchor.isActive = true
        return (view, widthAnchor)
    }
    
    
    struct ColorSet {
        var backgroundColor: UIColor
        var instantProgressColor: UIColor
        var delayedProgressColor: UIColor
    }
    
    // MARK: Glowing progress bar setup
    
    struct GlowingColorSet {
        var colorSet: ColorSet
        var outerGlowColor: UIColor
        var innerGlowColor: UIColor
    }
    
    private static let defaultGlowingColorSet = GlowingColorSet(colorSet: ColorSet(backgroundColor: #colorLiteral(red: 0.1549557745, green: 0.2322508395, blue: 0.328158915, alpha: 1), instantProgressColor: #colorLiteral(red: 0.4235294118, green: 0.6549019608, blue: 1, alpha: 1).withAlphaComponent(0.5), delayedProgressColor: #colorLiteral(red: 0.4235294118, green: 0.6549019608, blue: 1, alpha: 1)), outerGlowColor: .blue, innerGlowColor: .white)
    
    private var selectedGlowingColorSet: GlowingColorSet!
    
    /// Glowing methods don't relate to common methods because they use a bit different logic
    public func configureGlowing(colorSet: GlowingColorSet = defaultGlowingColorSet, roundedCorners: Bool = true, animationTime: Double = 0.35, animationDelay: Double = 0) {
        selectedGlowingColorSet = colorSet
        self.roundedCorners = roundedCorners
        self.animationTime = animationTime
        self.animationDelay = animationDelay
        
        commonGlowingInit()
    }
    
    public func configureGlowing(colorSet: GlowingColorSet = defaultGlowingColorSet, roundedCorners: Bool = true, previousProgress: Double, currentProgress: Double, animationTime: Double = 0.35, animationDelay: Double = 0) {
        self.configureGlowing(colorSet: colorSet, roundedCorners: roundedCorners, animationTime: animationTime, animationDelay: animationDelay)
        setGlowingProgress(previousProgress: previousProgress, currentProgress: currentProgress)
    }
    
    
    public func configureGlowingAndAnimate(colorSet: GlowingColorSet = defaultGlowingColorSet, roundedCorners: Bool = true, previousProgress: Double, currentProgress: Double, animationTime: Double = 0.35, animationDelay: Double = 0) {
        self.configureGlowing(colorSet: colorSet, roundedCorners: roundedCorners, animationTime: animationTime, animationDelay: animationDelay)
        
        setGlowingProgress(previousProgress: previousProgress, currentProgress: currentProgress)
        animateGlowingProgress()
    }
    
    
    /// simlpy set glowing progress
    public func setGlowingProgress(previousProgress: Double, currentProgress: Double) {
        checkProgresses([previousProgress, currentProgress])
        recordedPriveousProgress = previousProgress
        recordedCurrentProgress = currentProgress
        
        instantProgressViewWidthConstraint.constant = bounds.width * CGFloat(currentProgress)
        
        let finalProgressPercents = currentProgress - previousProgress
        delayedProgressViewWidthConstraint.constant = bounds.width * CGFloat(finalProgressPercents)
        
        // subview for inner shadow
        layoutSubviews()
        
        let widthPercents = 0.7
        let heightPercents: CGFloat = 0.5
        
        let innerShadowView = UIView()
        self.innerShadowView = innerShadowView
        innerShadowView.frame = CGRect(x: (delayedProgressView.bounds.width * (1 - widthPercents)) / 2, y: (delayedProgressView.bounds.height * (1 - heightPercents)) / 2, width: delayedProgressView.bounds.width * widthPercents, height: delayedProgressView.bounds.height * heightPercents)
        
        delayedProgressView.addSubview(innerShadowView)
        innerShadowView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleHeight, .flexibleWidth]
        innerShadowView.backgroundColor = selectedGlowingColorSet.innerGlowColor
        innerShadowView.layer.cornerRadius = innerShadowView.bounds.height / 2
        
        let path = UIBezierPath(roundedRect: innerShadowView.bounds, cornerRadius: innerShadowView.bounds.height / 2)

        // Set the shadow properties
        innerShadowView.layer.shadowPath = path.cgPath
        innerShadowView.layer.shadowColor = selectedGlowingColorSet.innerGlowColor.cgColor
        innerShadowView.layer.shadowOpacity = 1
//        innerShadowView.layer.shadowRadius = (delayedProgressView.bounds.height - innerShadowView.bounds.height) / 2
        innerShadowView.layer.shadowRadius = 5

        // Clip the view to its rounded corners
//        innerShadowView.clipsToBounds = true
    }
    
    var innerShadowView: UIView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let innerShadowView = innerShadowView {
            let path = UIBezierPath(roundedRect: innerShadowView.bounds, cornerRadius: innerShadowView.bounds.height / 2)
            innerShadowView.layer.shadowPath = path.cgPath
        }
        
    }
    
    /// animate glowing progress
    public func animateGlowingProgress() {
        layoutSubviews()
        UIView.animate(withDuration: animationTime, delay: animationDelay) {
            self.delayedProgressViewWidthConstraint.constant = 0
            self.layoutIfNeeded()
        }
    }
    
    enum ProgressViewType { case oldProgress, newProgress }
    
    private func commonGlowingInit() {
        //layer.masksToBounds = true
        backgroundColor = selectedGlowingColorSet.colorSet.backgroundColor
        
        let instantProgressViewTuple = createAndConstraintProgressView(progressViewType: .oldProgress)
        instantProgressView = instantProgressViewTuple.view
        instantProgressViewWidthConstraint = instantProgressViewTuple.widthConstraint
        instantProgressView.backgroundColor = selectedGlowingColorSet.colorSet.instantProgressColor
        
        let delayedProgressViewTuple = createAndConstraintProgressView(progressViewType: .newProgress)
        delayedProgressView = delayedProgressViewTuple.view
        delayedProgressViewWidthConstraint = delayedProgressViewTuple.widthConstraint
        delayedProgressView.backgroundColor = selectedGlowingColorSet.colorSet.delayedProgressColor
        
        // TODO: Turn on
        //delayedProgressView.layer.shadowColor = selectedGlowingColorSet.outerGlowColor.cgColor
        //delayedProgressView.layer.shadowOpacity = 1
        //delayedProgressView.layer.shadowRadius = 10
        
        layoutSubviews()
        if roundedCorners {
            DispatchQueue.main.async {
                self.layer.cornerRadius = self.bounds.height / 2
                self.instantProgressView.layer.cornerRadius = self.instantProgressView.bounds.height / 2
                self.delayedProgressView.layer.cornerRadius = self.delayedProgressView.bounds.height / 2
            }
        }
    }
    
    // make adjustment for rounded corners if enabled
    private func createAndConstraintProgressView(progressViewType: ProgressViewType) -> (view: UIView, widthConstraint: NSLayoutConstraint) {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        switch progressViewType {
        case .oldProgress:
            view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        case .newProgress:
            view.trailingAnchor.constraint(equalTo: instantProgressView.trailingAnchor).isActive = true
        }
        
        let widthAnchor = view.widthAnchor.constraint(equalToConstant: 0)
        widthAnchor.isActive = true
        
        return (view, widthAnchor)
    }
}
