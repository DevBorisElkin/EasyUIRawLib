//
//  ScalableWrapperView.swift
//  EasyUIRawLib
//
//  Created by test on 16.01.2023.
//

import UIKit

class ScalableWrapperView: UIView {
    private weak var wrapperHeight: NSLayoutConstraint!
    private weak var wrapperWidth: NSLayoutConstraint!
    
    private var subviewNaturalHeight: CGFloat = 0
    private var subviewNaturalWidth: CGFloat = 0
    
    private var subview: UIView?
    private var mainParentToLayoutSubviews: UIView?
    
    public enum Placement {
        case add(at: Int? = nil)
        case arrange(at: Int? = nil)
    }
    
    private func setWrapperConstraints() {
        mainParentToLayoutSubviews?.layoutIfNeeded()
        
        guard let subview = subview else { print("Unknown error!"); return }
        //self.superview?.layoutIfNeeded()
        print("Child view size: \(subview.bounds)")
        
        // check for height
        var selectedHeight: CGFloat = 0
        if let heightConstraint = subview.constraints.first(where: { item in
            item.firstAttribute.rawValue == NSLayoutConstraint.Attribute.height.rawValue
        }) {
            selectedHeight = heightConstraint.constant
        } else {
            selectedHeight = subview.bounds.height
        }
        subviewNaturalHeight = selectedHeight
        wrapperHeight = heightAnchor.constraint(equalToConstant: selectedHeight)
        wrapperHeight.isActive = true
        
        // check for width
        var selectedWidth: CGFloat = 0
        if let widthConstraint = subview.constraints.first(where: { item in
            item.firstAttribute.rawValue == NSLayoutConstraint.Attribute.width.rawValue
        }) {
            selectedWidth = widthConstraint.constant
        } else {
            selectedWidth = subview.bounds.width
        }
        subviewNaturalWidth = selectedWidth
        wrapperWidth = widthAnchor.constraint(equalToConstant: selectedWidth)
        wrapperWidth.isActive = true
    }
    
    public func configure(animatedSubview: UIView, parent: UIView, placement: Placement, mainParentToLayoutSubviews: UIView) {
        // 1) just in case
        animatedSubview.translatesAutoresizingMaskIntoConstraints = false
        parent.translatesAutoresizingMaskIntoConstraints = false
        
        self.mainParentToLayoutSubviews = mainParentToLayoutSubviews
        
        // 2) add view to parent and setup constraints if needed
        switch placement {
        case .add(let at):
            if let at = at {
                parent.insertSubview(self, at: at)
            } else {
                parent.addSubview(self)
            }
        case .arrange(let at):
            guard let stackViewParent = parent as? UIStackView else { fatalError("ScalableWrapperView.UnknownError") }
            if let at = at {
                stackViewParent.insertArrangedSubview(self, at: at)
            } else {
                stackViewParent.addArrangedSubview(self)
            }
        }
        
        // 3) add flexibleSubview onto wrapperView
        addSubview(animatedSubview)
        self.subview = animatedSubview
        animatedSubview.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        animatedSubview.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        // 4) configure constraints for wrapperView
        setWrapperConstraints()
    }
    
    /// squashes 'transform' of the element
    public func changeScale(newScale: CGFloat, animationTime: Double = 0, completion: (()->Void)? = nil) {
        guard let subview = subview else { print("Error: ScalableWrapperView.NoSubview"); return }
        
        guard animationTime > 0 else {
            subview.transform = CGAffineTransform(scaleX: newScale, y: newScale)
            wrapperHeight.constant = subviewNaturalHeight * newScale
            wrapperWidth.constant = subviewNaturalWidth * newScale
            return
        }
        
        wrapperHeight.constant = subviewNaturalHeight * newScale
        wrapperWidth.constant = subviewNaturalWidth * newScale
        UIView.animate(withDuration: animationTime, animations: {
            subview.transform = CGAffineTransform(scaleX: newScale, y: newScale)
            self.mainParentToLayoutSubviews?.layoutIfNeeded()
        }, completion: {_ in
            completion?()
        })
    }
    
    /// instantly folds the view by specified axis and then calls 'changeSize' with 'endSize' value. By default, 'endSize' is 1. 'Folded' state always has implicit 'startSize' as 0
    public func foldAndThenUnfoldSize(endSize: CGFloat = 1, axis: UIAxis, animationTime: Double = 0, zPositionChange: CGFloat = 0, completion: (()->Void)? = nil) {
        switch axis {
        case .horizontal:
            wrapperWidth.constant = 0
        case .vertical:
            wrapperHeight.constant = 0
        default:
            print("Only explicit horizontal or vertical axis tested and supported")
            return
        }
        
        mainParentToLayoutSubviews?.layoutIfNeeded()
        changeSize(endSize: endSize, axis: axis, animationTime: animationTime, zPositionChange: zPositionChange, completion: completion)
    }
    
    /// to fold or unfold the view by specified axis, in completion recommended to remove the view from superview if you're intended to fold it
    public func changeSize(endSize: CGFloat, axis: UIAxis, animationTime: Double = 0, zPositionChange: CGFloat = 0, completion: (()->Void)? = nil) {
        guard let subview = subview else { print("Error: ScalableWrapperView.NoSubview"); return }
        layer.zPosition = layer.zPosition + zPositionChange
        
        wrapperHeight.constant = subviewNaturalHeight * endSize
        guard animationTime > 0 else { return }
        
        UIView.animate(withDuration: animationTime, animations: {
            self.mainParentToLayoutSubviews?.layoutIfNeeded()
        }, completion: {_ in
            completion?()
        })
    }
}
