//
//  ScrollViewFactory.swift
//  EasyUIRawLib
//
//  Created by test on 05.12.2022.
//

import UIKit

class ScrollViewFactory {
    
    public static func createStackedScrollView(putInto parent: UIView? = nil) -> StackedScrollView {
        let stackView = ContentStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        let scrollView = initScrollView(putInto: parent, container: stackView)
        
        let stackedScrollView = StackedScrollView(scrollView: scrollView, stackView: stackView)
        return stackedScrollView
    }
    
    public static func initScrollView(putInto parent: UIView? = nil, container:UIView, hookUpToParent: Bool = true) -> UIScrollView{
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.clear
        scrollView.contentInsetAdjustmentBehavior = .always
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        container.putTo(parent: scrollView)
        scrollView.contentLayoutGuide.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
        scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        
        if let parent = parent {
            if hookUpToParent {
                scrollView.putTo(parent: parent)
            } else {
                parent.addSubview(scrollView)
            }
        }
        return scrollView
    }
    
    class StackedScrollView {
        let scrollView: UIScrollView
        let stackView: ContentStackView
        init(scrollView: UIScrollView, stackView: ContentStackView) {
            self.scrollView = scrollView
            self.stackView = stackView
        }
    }
    
    class ContentStackView: UIStackView {
        func addContent(contentView: UIView, at: Int? = nil) {
            if let at = at {
                insertArrangedSubview(contentView, at: at)
            } else {
                addArrangedSubview(contentView)
            }
        }
        
        func clearContent() {
            removeAllArrangedSubviews()
        }
    }
}
