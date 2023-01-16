//
//  Example_5_ScalingDownByTransform.swift
//  EasyUIRawLib
//
//  Created by test on 16.01.2023.
//

import UIKit

class Example_5_ScalingDownByTransform: UIViewController {
    
    @IBOutlet weak var viewToScale_1: UIView!
    @IBOutlet weak var viewToScale_2: UIView!
    
    @IBOutlet weak var scalableWrapperView_1: ScalableWrapperView!
    
    
    override func viewDidLoad() {
        //viewToScale_1.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        //viewToScale_2.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        scalableWrapperView_1.changeHeight2(scale: 0.5)
    }
}
