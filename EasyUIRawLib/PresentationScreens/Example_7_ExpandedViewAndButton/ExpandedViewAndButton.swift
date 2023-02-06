//
//  ExpandedButton.swift
//  EasyUIRawLib
//
//  Created by test on 06.02.2023.
//

import UIKit

class ExpandedButton: UIButton {
    @IBInspectable var clickIncreasedArea: CGPoint = .zero
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -clickIncreasedArea.x, dy: -clickIncreasedArea.y).contains(point)
    }
}

class ExpandedView: UIView {
    @IBInspectable var clickIncreasedArea: CGPoint = .zero
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -clickIncreasedArea.x, dy: -clickIncreasedArea.y).contains(point)
    }
}
