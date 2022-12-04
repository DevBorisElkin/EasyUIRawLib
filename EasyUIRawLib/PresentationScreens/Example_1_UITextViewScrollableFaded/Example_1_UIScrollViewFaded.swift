//
//  Example_1_UITextViewScrollableFaded.swift
//  EasyUIRawLib
//
//  Created by test on 04.12.2022.
//

import UIKit

class Example_1_UIScrollViewFaded: UIViewController {
    
    override func viewDidLoad() {
        let nib = nib(name: "Example_1_ScrollView") as! Example_1_ScrollView
        let scrollView = ScrollViewFactory.initScrollView(putInto: view, container: nib)
    }
    
}
