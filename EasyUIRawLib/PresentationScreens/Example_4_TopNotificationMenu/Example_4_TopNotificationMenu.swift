//
//  Example_4_TopNotificationMenu.swift
//  EasyUIRawLib
//
//  Created by test on 20.12.2022.
//

import UIKit

class Example_4_TopNotificationMenu: UIViewController {
    
    @IBOutlet weak var animationTimeField: UITextField!
    @IBOutlet weak var hangUpTimeField: UITextField!
    
    weak var lastOpenedTopMenu: TopNotificationView?
    
    @IBAction func test_1_showSimpleNotification() {
        let contentView = createContentView()
        
        let notificationMenu = TopNotificationView()
        notificationMenu.configure(openOnto: self.view, contentView: contentView, animationTime: 0.3, notificationDisplayTime: 3, topPosition: .onTopOfStatusBar(offset: 0))
    }
    
    @IBAction func test_2_createConfigured() {
        //let contentView = createContentView()
        let contentView = createContentViewWithClosingTouch()
        
        let animationTime: Double = Double(animationTimeField.text ?? "0.1") ?? 0.1
        let hangUpTime: Double = Double(hangUpTimeField.text ?? "1") ?? 1
        
        lastOpenedTopMenu = TopNotificationView.createAndConfigure(openOnto: self.view, contentView: contentView, animationTime: animationTime, notificationDisplayTime: hangUpTime, topPosition: .onTopOfStatusBar(offset: 0))
    }
    
    
    
    private func createContentView() -> UIView {
        let contentView = UIView()
        contentView.backgroundColor = .red
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        return contentView
    }
    
    private func createContentViewWithClosingTouch() -> UIView {
        let contentView = UIView()
//        let contentView = ClickAnimatedView()
//        contentView.awakeFromNib()
        contentView.backgroundColor = .red
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeLastOpenedTopMenu))
        contentView.addGestureRecognizer(tapGestureRecognizer)
        return contentView
    }
    
    @objc private func closeLastOpenedTopMenu(_ sender: UITapGestureRecognizer) {
        print("tapped on view, should start closing")
        lastOpenedTopMenu?.closeNotificationViewManually()
    }
}
