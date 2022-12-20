//
//  Example_4_TopNotificationMenu.swift
//  EasyUIRawLib
//
//  Created by test on 20.12.2022.
//

import UIKit

class Example_4_TopNotificationMenu: UIViewController {
    
    @IBAction func test_1_showSimpleNotification() {
        let contentView = createContentView()
        
        let notificationMenu = TopNotificationMenu()
        notificationMenu.configure(openOnto: self.view, contentView: contentView, animationTime: 0.3, notificationDisplayTime: 2, topPosition: .onTopOfStatusBar(offset: 0))
    }
    
    
    private func createContentView() -> UIView {
        let contentView = UIView()
        contentView.backgroundColor = .red
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        return contentView
    }
}
