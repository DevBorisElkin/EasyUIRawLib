//
//  Example_3_DelayedProgressBar.swift
//  EasyUIRawLib
//
//  Created by test on 20.12.2022.
//

import UIKit

class Example_3_DelayedProgressBar: UIViewController {
    
    let backgroundColor = #colorLiteral(red: 0.1549557745, green: 0.2322508395, blue: 0.328158915, alpha: 1)
    let mainColor = #colorLiteral(red: 0.4235294118, green: 0.6549019608, blue: 1, alpha: 1)
    
    override func viewDidLoad() {
        delayedProgressBar.configure(colorSet: DelayedProgressBar.ColorSet(backgroundColor: backgroundColor, instantProgressColor: mainColor.withAlphaComponent(0.5), delayedProgressColor: mainColor), progressAnimationTime: 0.5, roundedCorners: true)
    }
    
    @IBOutlet weak var delayedProgressBar: DelayedProgressBar!
    
    @IBAction func setBarProgress() {
        delayedProgressBar.setProgressAndAnimate(previousProgress: 0.4, currentProgress: 0.65)
    }
    
    @IBAction func setBarProgressNoAnimate() {
        delayedProgressBar.setProgress(previousProgress: 0.4, currentProgress: 0.8)
    }
    
    @IBAction func animateBarProgress() {
        delayedProgressBar.animate()
    }
}
