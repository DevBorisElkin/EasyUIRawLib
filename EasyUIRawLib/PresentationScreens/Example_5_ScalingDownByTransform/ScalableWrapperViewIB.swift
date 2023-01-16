//
//  ScalableWrapperView.swift
//  EasyUIRawLib
//
//  Created by test on 16.01.2023.
//

import UIKit

// decided for now to support only code version of it
//class ScalableWrapperView: UIView {
//    @IBInspectable var copyHeightConstraint: Bool = false
//    @IBInspectable var copyWidthConstraint: Bool = false
//
//    weak var wrapperHeight: NSLayoutConstraint!
//    weak var wrapperWidth: NSLayoutConstraint!
//
//    var heightConstraint: ConstraintReference?
//    var widthConstraint: ConstraintReference?
//
//
//public enum ViewCalculates {
//    case none
//    case height
//    case width
//    case fullSize
//    case configure(willTakeSize: CGSize)
//}
//
//    var subview: UIView?
//
//    // needs advanced version that checks whether that subview already has required constraints
//    func hookUpSubviewToMiddle(subview: UIView) {
//        self.subview = subview
//        subview.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        subview.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//    }
//
//    override func awakeFromNib() {
//        guard subviews.count > 0 else { return }
//        guard subviews.count == 1 else { print("ScalableWrapperView.SubviewsCount: \(subviews.count) is too big, only 1 subview is allowed!"); return }
//        let viewToApplyTo = subviews[0]
//        hookUpSubviewToMiddle(subview: viewToApplyTo)
//
//        // check for height
//        if copyHeightConstraint, let heightConstraint = viewToApplyTo.constraints.first(where: { item in
//            item.firstAttribute.rawValue == NSLayoutConstraint.Attribute.height.rawValue
//        }) {
//            self.heightConstraint = ConstraintReference(constraint: heightConstraint, initialValue: heightConstraint.constant)
//            wrapperHeight = heightAnchor.constraint(equalToConstant: heightConstraint.constant)
//            wrapperHeight.isActive = true
//        }
//        // check for width
//        if copyWidthConstraint, let widthConstraint = viewToApplyTo.constraints.first(where: { item in
//            item.firstAttribute.rawValue == NSLayoutConstraint.Attribute.width.rawValue
//        }) {
//            self.widthConstraint = ConstraintReference(constraint: widthConstraint, initialValue: widthConstraint.constant)
//            wrapperWidth = widthAnchor.constraint(equalToConstant: widthConstraint.constant)
//            wrapperWidth.isActive = true
//        }
//    }
//
//    /*
//     CGFloat scaleX = view.transform.a;
//     CGFloat scaleY = view.transform.d;
//     */
//
//    // todo add animated version, add new scale parameter
//    func changeScale(newScale: CGFloat) {
//        guard let subview = subview else { print("Error: ScalableWrapperView.NoSubview"); return }
//        guard let heightConstraintHolder = heightConstraint, let widthConstraintHolder = widthConstraint else { print("Error: ScalableWrapperView.NoHeightOrWidthConstraint"); return }
//        subview.transform = CGAffineTransform(scaleX: newScale, y: newScale)
//        wrapperHeight.constant = heightConstraintHolder.initialValue * newScale
//        wrapperWidth.constant = widthConstraintHolder.initialValue * newScale
//    }
//
//    // good to hide the view
//    func squashHeight(scale: CGFloat, zPositionChange: CGFloat = -10) {
//        guard let subview = subview else { print("Error: ScalableWrapperView.NoSubview"); return }
//        guard let heightConstraintHolder = heightConstraint, let heightConstraint = heightConstraintHolder.constraint else { print("Error: ScalableWrapperView.NoHeightConstraint"); return }
////        subview.transform = CGAffineTransform(scaleX: scale, y: scale)
//        layer.zPosition = layer.zPosition + zPositionChange
//        wrapperHeight.constant = heightConstraintHolder.initialValue * scale
//        wrapperWidth.constant = widthConstraint!.initialValue * scale
//    }
//
//    class ConstraintReference {
//        weak var constraint: NSLayoutConstraint?
//        var initialValue: CGFloat
//
//        init(constraint: NSLayoutConstraint, initialValue: CGFloat) {
//            self.constraint = constraint
//            self.initialValue = initialValue
//        }
//    }
//}
