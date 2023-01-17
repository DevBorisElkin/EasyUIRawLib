//
//  ScalableWrapperView.swift
//  EasyUIRawLib
//
//  Created by test on 16.01.2023.
//

// raw version but should be working
// use it to scale-down, fold elements in stack view with no gaps remaining
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
    public enum Axis {
        case horizontal
        case vertical
    }
    public enum Size {
        case zero
        case one
        case custom(value: CGFloat)
        
        func asociatedValue() -> CGFloat {
            switch self {
            case .zero: return 0
            case .one: return 1
            case .custom(let value): return value
            }
        }
        
        func equivalent() -> Size {
            switch self {
            case .custom(value: let value): return value<0.5 ? .zero : .one
            default: return self
            }
    
        }
        
        static func ==(lhs: Size, rhs: Size) -> Bool {
            switch (lhs, rhs) {
            case (.zero, .zero): return true
            case (.one, .one): return true
            case (.custom(_), .custom(_)): return true
            default: return false
            }
        }
    }
    
    private func setWrapperConstraints() {
        mainParentToLayoutSubviews?.layoutIfNeeded()
        
        guard let subview = subview else { print("Unknown error!"); return }
        //self.superview?.layoutIfNeeded()
        //print("Child view size: \(subview.bounds)")
        
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
    
    // ---set values
    // changeScale (completely change x,y scale and fold)
    // changeSize (fold by one axis)
    //
    // ---use predifined methods
    // scaleIn
    // scaleOut
    //
    // sizeIn
    // sizeOut
    
    // MARK: Changing Scale
    
    public func scaleIn(animationTime: Double = 0, completion: (()->Void)? = nil) {
        changeScale(newScale: 1, animationTime: animationTime, completion: completion)
    }
    
    public func scaleOut(animationTime: Double = 0, completion: (()->Void)? = nil) {
        changeScale(newScale: 0, animationTime: animationTime, completion: completion)
    }
    
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
            let selectedScale = max(0.01, newScale)
            subview.transform = CGAffineTransform(scaleX: selectedScale, y: selectedScale)
            self.mainParentToLayoutSubviews?.layoutIfNeeded()
        }, completion: {_ in
            completion?()
        })
    }
    
    
    
    // MARK: Changing Size
    
    public func sizeIn(axis: Axis, animationTime: Double = 0, additionalAniamation: Bool = false, completion: (()->Void)? = nil) {
        changeSize(newSize: 1, axis: axis, animationTime: animationTime, completion: completion)
    }
    
    public func sizeOut(axis: Axis, animationTime: Double = 0, additionalAniamation: Bool = false, completion: (()->Void)? = nil) {
        changeSize(newSize: 0, axis: axis, animationTime: animationTime, completion: completion)
    }
    
    /// to fold or unfold the view by specified axis, in completion recommended to remove the view from superview if you're intended to fold it
    public func changeSize(newSize: CGFloat, axis: Axis, animationTime: Double = 0, completion: (()->Void)? = nil) {
        guard let subview = subview else { print("Error: ScalableWrapperView.NoSubview"); return }
        layer.masksToBounds = true
        
        switch axis {
        case .horizontal:
            self.wrapperWidth.constant = self.subviewNaturalWidth * newSize
        case .vertical:
            self.wrapperHeight.constant = self.subviewNaturalHeight * newSize
        }
        
        guard animationTime > 0 else { self.mainParentToLayoutSubviews?.layoutIfNeeded(); return }
        
        UIView.animate(withDuration: animationTime, animations: {
            self.mainParentToLayoutSubviews?.layoutIfNeeded()
        }, completion: {_ in
            completion?()
        })
    }
    
    /// instantly folds the view by specified axis and then calls 'changeSize' with 'endSize' value. By default, 'endSize' is 1. 'Folded' state always has implicit 'startSize' as 0
//    public func sizeOutInstSizeInAnimated(endSize: CGFloat = 1, axis: Axis, animationTime: Double = 0, completion: (()->Void)? = nil) {
//        layer.masksToBounds = true
//        switch axis {
//        case .horizontal:
//            wrapperWidth.constant = 0
//        case .vertical:
//            wrapperHeight.constant = 0
//        default:
//            print("Only explicit horizontal or vertical axis tested and supported")
//            return
//        }
//
//        mainParentToLayoutSubviews?.layoutIfNeeded()
//        changeSize(newSize: endSize, axis: axis, animationTime: animationTime, completion: completion)
//    }
    
    private func calculateCurrentSize(axis: Axis) -> CGFloat {
        switch axis {
        case .horizontal:
            return wrapperWidth.constant / subviewNaturalWidth
        case .vertical:
            return wrapperHeight.constant / subviewNaturalHeight
        }
    }
    
    /// for complete folding and unfolding
    public func changeSizeWithFoldingAnimation(newSize: Size, axis: Axis, animationTime: Double = 0.5, mainAnimationDelay: Double = 0.3, completion: (()->Void)? = nil, ignoreCurrectSize: Bool = false) {
        guard let subview = subview else { print("Error: ScalableWrapperView.NoSubview"); return }
        
        layer.masksToBounds = true
        
        guard animationTime > 0 else { print("Error: ScalableWrapperView.required animation time"); return }
        
        let delayScaleAlpha: CGFloat = newSize.equivalent() == .zero ? 0 : mainAnimationDelay
        let durationScaleAlpha: CGFloat = newSize.equivalent() == .zero ? animationTime + mainAnimationDelay : animationTime
        
        let delayConstant: CGFloat = newSize.equivalent() == .zero ? mainAnimationDelay : 0
        let durationConstant: CGFloat = newSize.equivalent() == .zero ? animationTime : animationTime + mainAnimationDelay
        
        
        // additional animation
        self.subview?.transform = newSize.equivalent() == .zero ? subview.transform : CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.subview?.alpha = newSize.equivalent() == .zero ? 1 : 0
        UIView.animate(withDuration: durationScaleAlpha, delay: delayScaleAlpha) {
            self.subview?.transform = newSize.equivalent() == .zero ? CGAffineTransform(scaleX: 0.5, y: 0.5) : CGAffineTransform(scaleX: newSize.asociatedValue(), y: newSize.asociatedValue())
            self.subview?.alpha = newSize.equivalent() == .zero ? 0 : 1
        }
        // end additional animation
        
        UIView.animate(withDuration: durationConstant, delay: delayConstant, animations: {
            switch axis {
            case .horizontal:
                self.wrapperWidth.constant = self.subviewNaturalWidth * newSize.asociatedValue()
            case .vertical:
                self.wrapperHeight.constant = self.subviewNaturalHeight * newSize.asociatedValue()
            }
            self.mainParentToLayoutSubviews?.layoutIfNeeded()
        }, completion: {_ in
            completion?()
        })
    }
}
