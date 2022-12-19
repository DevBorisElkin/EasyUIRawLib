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
    
    // todo add ability to set up via nib
    override func awakeFromNib() {}
    
    func configure(colorSet: ColorSet, progressAnimationTime: Double) {
        selectedColorSet = colorSet
        self.progressAnimationTime = progressAnimationTime
        commonInit()
    }
    
    private func commonInit() {
        let instantProgressViewTuple = createAndConstraintProgressView()
        instantProgressView = instantProgressViewTuple.view
        instantProgressViewWidthConstraint = instantProgressViewTuple.widthConstraint
        instantProgressView.backgroundColor = selectedColorSet.instantProgressColor
        
        let delayedProgressViewTuple = createAndConstraintProgressView()
        delayedProgressView = delayedProgressViewTuple.view
        delayedProgressViewWidthConstraint = delayedProgressViewTuple.widthConstraint
        delayedProgressView.backgroundColor = selectedColorSet.delayedProgressColor
    }
    
    // unnecessary layout subviews
    func showProgress(previousProgress: Double, currentProgress: Double) {
        layoutSubviews()
        checkProgress(previousProgress)
        checkProgress(currentProgress)
        instantProgressViewWidthConstraint.constant = bounds.width * CGFloat(currentProgress)
        layoutSubviews()
        delayedProgressViewWidthConstraint.constant = bounds.width * CGFloat(previousProgress)
        UIView.animate(withDuration: progressAnimationTime) {
            self.layoutSubviews()
        }
    }
    
    private func checkProgress(_ progress: Double) {
        guard progress >= 0 && progress <= 1  else { return }
        fatalError("Error! Progress should be within 0...1 range!")
    }
    
    private func createAndConstraintProgressView() -> (view: UIView, widthConstraint: NSLayoutConstraint) {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        let widthAnchor = view.widthAnchor.constraint(equalTo: widthAnchor)
        widthAnchor.isActive = true
        return (view, widthAnchor)
    }
    
    
    struct ColorSet {
        var backgroundColor: UIColor
        var instantProgressColor: UIColor
        var delayedProgressColor: UIColor
    }
}
