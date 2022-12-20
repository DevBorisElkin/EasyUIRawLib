//
//  TopNotificationView.swift
//  EasyUIRawLib
//
//  Created by test on 20.12.2022.
//

import UIKit

class TopNotificationView: UIView {
    
    private weak var openOnto: UIView?
    
    private var animationTime: Double = 0.25
    private var notificationDisplayTime: Double = 4
    private var topPosition: TopPosition = .onTop(offset: 0)
    var closingCompletion: (()->Void)?
    
    private var topConstraint: NSLayoutConstraint!
    
    private let operationQueue = OperationQueue()
    private var closingOperation: BlockOperation?
    
    private var oneTimeClosingFlag = true
    
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    /// notificationDisplayTime - if less then 0, the notification view will never get closed
    public static func createAndConfigure(openOnto: UIView, contentView: UIView, animationTime: Double = 0.25, notificationDisplayTime: Double = 4, topPosition: TopPosition = .onTop(offset: 0), closingCompletion: (()->Void)? = nil) -> TopNotificationView {
        let notificationView = TopNotificationView()
        notificationView.configure(openOnto: openOnto, contentView: contentView, animationTime: animationTime, notificationDisplayTime: notificationDisplayTime, topPosition: topPosition, closingCompletion: closingCompletion)
        return notificationView
    }
    /// notificationDisplayTime - if less then 0, the notification view will never get closed
    func configure(openOnto: UIView, contentView: UIView, animationTime: Double = 0.25, notificationDisplayTime: Double = 4, topPosition: TopPosition = .onTop(offset: 0), closingCompletion: (()->Void)? = nil) {
        self.openOnto = openOnto
        self.animationTime = animationTime
        self.notificationDisplayTime = notificationDisplayTime
        self.closingCompletion = closingCompletion
        
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
            calculatedTopPosition = TopNotificationView.statusBarHeight + offset
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
        guard notificationDisplayTime >= 0 else {
            return
        }
        closingOperation = BlockOperation(block: { [weak self] in
            Thread.sleep(forTimeInterval: self?.notificationDisplayTime ?? 0)
            if let isCancelled = self?.closingOperation?.isCancelled, !isCancelled {
                DispatchQueue.main.async {
                    self?.closeNotificationView()
                }
            }
        })
        operationQueue.addOperation(closingOperation!)
    }
    
    @objc func closeNotificationViewManually() {
        closingOperation?.cancel()
        closeNotificationView()
    }
    
    private func closeNotificationView() {
        guard oneTimeClosingFlag else { return }
        oneTimeClosingFlag = false
        guard let openOnto = openOnto else { removeFromSuperview(); return }
        
        openOnto.layoutSubviews()
        self.topConstraint.constant = -self.bounds.height
        UIView.animate(withDuration: animationTime) {
            openOnto.layoutSubviews()
        } completion: { [weak self] _ in
            self?.closingCompletion?()
            self?.removeFromSuperview()
        }
    }
    
    enum TopPosition {
        case onTop(offset: CGFloat)
        case onTopOfStatusBar(offset: CGFloat)
    }
}
