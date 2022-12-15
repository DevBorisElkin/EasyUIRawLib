//
//  TestScrollView.swift
//  EasyUIRawLib
//
//  Created by test on 15.12.2022.
//

import UIKit

class TestScrollView: UIScrollView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        delaysContentTouches = false
    }
}
