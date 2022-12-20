//
//  TopNotificationMenu.swift
//  EasyUIRawLib
//
//  Created by test on 20.12.2022.
//

import UIKit

class TopNotificationMenu: UIView {
    
    private weak var openOnto: UIView?
    
    private var animationTime: Double = 0.25
    private var notificationDisplayTime: Double = 4
    private var topPosition: TopPosition = .onTop(offset: 0)
    
    private var topConstraint: NSLayoutConstraint!
    
    let operationQueue = OperationQueue()
    var closingOperation: BlockOperation?
    
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    func configure(openOnto: UIView, contentView: UIView, animationTime: Double = 0.25, notificationDisplayTime: Double = 4, topPosition: TopPosition = .onTop(offset: 0)) {
        self.openOnto = openOnto
        self.animationTime = animationTime
        self.notificationDisplayTime = notificationDisplayTime
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        openOnto.addSubview(self)
        self.centerXAnchor.constraint(equalTo: openOnto.centerXAnchor).isActive = true
        openOnto.layoutSubviews()
        self.topConstraint = self.topAnchor.constraint(equalTo: openOnto.topAnchor, constant: -bounds.height)
        self.topConstraint.isActive = true
        openOnto.layoutSubviews()
        
        // show smooth appear animation
        
        var calculatedTopPosition: CGFloat = 0
        switch topPosition {
        case .onTop(offset: let offset):
            calculatedTopPosition = offset
        case .onTopOfStatusBar(offset: let offset):
            calculatedTopPosition = TopNotificationMenu.statusBarHeight + offset
        @unknown default: fatalError("Specify all enum cases of TopPosition!")
        }
        
        self.topConstraint.constant = calculatedTopPosition
        UIView.animate(withDuration: animationTime) {
            openOnto.layoutSubviews()
        } completion: { [weak self] _ in
            self?.startClosingCountdown()
        }
    }
    
    private func startClosingCountdown() {
        closingOperation = BlockOperation(block: { [weak self] in
            Thread.sleep(forTimeInterval: self?.notificationDisplayTime ?? 0)
            if let isCancelled = self?.closingOperation?.isCancelled, !isCancelled {
                DispatchQueue.main.async {
                    self?.closeNotificationMenu()
                }
            }
        })
        operationQueue.addOperation(closingOperation!)
    }
    
    @objc func closeNotificationMenuManually() {
        print("closeNotificationMenuManually")
        closingOperation?.cancel()
        closeNotificationMenu()
    }
    
    private func closeNotificationMenu() {
        //print("closeNotificationMenu")
        self.topConstraint.constant = -bounds.height
        
        //print("openOnto != nil: \(openOnto != nil)")
        
        guard let openOnto = openOnto else {
            //print("Close instantly")
            self.removeFromSuperview()
            return
        }
        //print("Close smoothly")
        
        UIView.animate(withDuration: animationTime) {
            openOnto.layoutSubviews()
        } completion: { [weak self] _ in
            self?.removeFromSuperview()
        }
    }
    
    enum TopPosition {
        case onTop(offset: CGFloat)
        case onTopOfStatusBar(offset: CGFloat)
    }
}
