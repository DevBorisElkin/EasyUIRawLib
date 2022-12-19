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
    private var progressAnimationTime: Double!
    private var roundedCorners: Bool!
    
    private var recordedPriveousProgress: Double = 0
    private var recordedCurrentProgress: Double = 0
    
    // todo add ability to set up via nib
    override func awakeFromNib() {}
    
    func configure(colorSet: ColorSet, progressAnimationTime: Double, roundedCorners: Bool) {
        selectedColorSet = colorSet
        self.progressAnimationTime = progressAnimationTime
        self.roundedCorners = roundedCorners
        commonInit()
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
        
        if roundedCorners {
            DispatchQueue.main.async {
                self.instantProgressView.layer.cornerRadius = self.instantProgressView.bounds.height / 2
                self.delayedProgressView.layer.cornerRadius = self.delayedProgressView.bounds.height / 2
            }
        }
    }
    
    // unnecessary layout subviews
    func setProgressAndAnimate(previousProgress: Double, currentProgress: Double) {
        layoutSubviews()
        checkProgresses([previousProgress, currentProgress])
        delayedProgressViewWidthConstraint.constant = bounds.width * CGFloat(previousProgress)
        instantProgressViewWidthConstraint.constant = bounds.width * CGFloat(currentProgress)
        layoutSubviews()
        delayedProgressViewWidthConstraint.constant = bounds.width * CGFloat(currentProgress)
        UIView.animate(withDuration: progressAnimationTime) {
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
        UIView.animate(withDuration: progressAnimationTime) {
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
}
