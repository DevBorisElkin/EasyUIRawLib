//
//  ReadyElementsExtensions.swift
//  EasyUIRawLib
//
//  Created by test on 04.12.2022.
//

import UIKit

extension UIView {
    func insertGradientLayer(color1: UIColor, color2: UIColor, at: Int) -> CAGradientLayer {
        let layerGradient = CAGradientLayer()
        layerGradient.colors = [color1.cgColor, color2.cgColor]
        
        layerGradient.frame = bounds
        layerGradient.startPoint = CGPoint(x: 0, y: 0)
        layerGradient.endPoint = CGPoint(x: 0, y: 1)
        
        layer.insertSublayer(layerGradient, at: UInt32(at))
        return layerGradient
    }
    
    func addGradientLayer(color1: UIColor, color2: UIColor) -> CAGradientLayer {
        let layerGradient = CAGradientLayer()
        layerGradient.colors = [color1.cgColor, color2.cgColor]
        
        layerGradient.frame = bounds
        layerGradient.startPoint = CGPoint(x: 0, y: 0)
        layerGradient.endPoint = CGPoint(x: 0, y: 1)
        
        layer.addSublayer(layerGradient)
        return layerGradient
    }
}
