//
//  Extensions.swift
//  EasyUIRawLib
//
//  Created by test on 04.12.2022.
//

import UIKit

func nib(name:String) -> UIView? {
    return Bundle.main.loadNibNamed(name, owner: nil, options: nil)![0] as? UIView
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func centerXTo(parent:UIView?) {
        if parent == nil { return }
        parent!.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: parent!.centerXAnchor).isActive = true
    }
    func centerYTo(parent:UIView?) {
        if parent == nil { return }
        parent!.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: parent!.centerYAnchor).isActive = true
    }
    func widthTo(parent:UIView?) {
        if parent == nil { return }
        parent!.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: parent!.widthAnchor).isActive = true
    }
    func heightTo(parent:UIView?) {
        if parent == nil { return }
        parent!.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: parent!.heightAnchor).isActive = true
    }
    func centerTo(parent:UIView?) {
        centerXTo(parent: parent)
        centerYTo(parent: parent)
    }
    @objc func putTo(parent:UIView?){
        if parent == nil{
            return
        }
        parent!.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: parent!.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: parent!.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parent!.bottomAnchor).isActive = true
        topAnchor.constraint(equalTo: parent!.topAnchor).isActive = true
    }
    @objc func putTo(parent:UIView?, at: Int){
        if parent == nil{
            return
        }
        parent!.insertSubview(self, at: at)
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: parent!.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: parent!.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parent!.bottomAnchor).isActive = true
        topAnchor.constraint(equalTo: parent!.topAnchor).isActive = true
    }
    @objc func putTo(parent:UIView?, sideConstant:Int){
        if parent == nil{
            return
        }
        parent!.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: parent!.leadingAnchor, constant: CGFloat(sideConstant)).isActive = true
        trailingAnchor.constraint(equalTo: parent!.trailingAnchor, constant: -CGFloat(sideConstant)).isActive = true
        bottomAnchor.constraint(equalTo: parent!.bottomAnchor).isActive = true
        topAnchor.constraint(equalTo: parent!.topAnchor).isActive = true
    }
    @objc func putTo(parent:UIView?, allConstant:Int){
        if parent == nil{
            return
        }
        parent!.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: parent!.leadingAnchor, constant: CGFloat(allConstant)).isActive = true
        trailingAnchor.constraint(equalTo: parent!.trailingAnchor, constant: -CGFloat(allConstant)).isActive = true
        bottomAnchor.constraint(equalTo: parent!.bottomAnchor, constant: -CGFloat(allConstant)).isActive = true
        topAnchor.constraint(equalTo: parent!.topAnchor, constant: CGFloat(allConstant)).isActive = true
    }
    @objc func putTo(parent:UIView?, leading:Int, top:Int, trailing:Int, bottom:Int){
        if parent == nil{
            return
        }
        parent!.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: parent!.leadingAnchor, constant: CGFloat(leading)).isActive = true
        trailingAnchor.constraint(equalTo: parent!.trailingAnchor, constant: CGFloat(-trailing)).isActive = true
        bottomAnchor.constraint(equalTo: parent!.bottomAnchor, constant: CGFloat(-bottom)).isActive = true
        topAnchor.constraint(equalTo: parent!.topAnchor, constant: CGFloat(top)).isActive = true
    }
    @objc func putTo(parent:UIView?, top:Bool, leading:Bool, trailing:Bool, bottom:Bool, allConstant:Int){
        if parent == nil{
            return
        }
        parent!.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        if leading {
            leadingAnchor.constraint(equalTo: parent!.leadingAnchor, constant: CGFloat(allConstant)).isActive = true
        }
        if trailing {
            trailingAnchor.constraint(equalTo: parent!.trailingAnchor, constant: -CGFloat(allConstant)).isActive = true
        }
        if bottom {
            bottomAnchor.constraint(equalTo: parent!.bottomAnchor, constant: -CGFloat(allConstant)).isActive = true
        }
        if top {
            topAnchor.constraint(equalTo: parent!.topAnchor, constant: CGFloat(allConstant)).isActive = true
        }
    }
    
    @objc func putToCenterY(parent:UIView?){
        guard let parent = parent else { return }
        parent.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
        leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
    }
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat, offset:CGFloat) -> CALayer {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: offset, y: offset, width: thickness, height: frame.height - offset * 2); break
        case .Right: border.frame = CGRect(x: bounds.width - offset - thickness, y: offset, width: thickness, height: frame.height - offset * 2); break
        case .Top: border.frame = CGRect(x: offset, y: offset, width: frame.width - offset * 2, height: thickness); break
        case .Bottom: border.frame = CGRect(x: offset, y: bounds.height - offset - thickness, width: frame.width - offset * 2, height: thickness); break
        }
        
        layer.addSublayer(border)
        return border
    }
    
    func addBorders(withColor color: CGColor, andThickness thickness: CGFloat, withOffset offset: CGFloat) -> [CALayer] {
        var borders = [
            addBorder(toSide: .Top, withColor: color, andThickness: thickness, offset: offset),
            addBorder(toSide: .Bottom, withColor: color, andThickness: thickness, offset: offset),
            addBorder(toSide: .Left, withColor: color, andThickness: thickness, offset: offset),
            addBorder(toSide: .Right, withColor: color, andThickness: thickness, offset: offset)
        ]
        return borders
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            NSLayoutConstraint.deactivate($0.constraints)
            $0.removeFromSuperview()
        }
    }
}
