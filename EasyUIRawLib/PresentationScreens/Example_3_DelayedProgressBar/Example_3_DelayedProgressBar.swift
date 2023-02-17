//
//  Example_3_DelayedProgressBar.swift
//  EasyUIRawLib
//
//  Created by test on 20.12.2022.
//

import UIKit

class Example_3_DelayedProgressBar: UIViewController {
    
    @IBOutlet weak var delayedProgressBar: DelayedProgressBar!
    
    @IBOutlet weak var secondDelayedProgressBar: DelayedProgressBar!
    
    @IBOutlet weak var delayedGlowingProgress: DelayedProgressBar!
    
    let backgroundColor = #colorLiteral(red: 0.1549557745, green: 0.2322508395, blue: 0.328158915, alpha: 1)
    let mainColor = #colorLiteral(red: 0.4235294118, green: 0.6549019608, blue: 1, alpha: 1)
    
    override func viewDidLoad() {
        let colorSet = DelayedProgressBar.ColorSet(backgroundColor: backgroundColor, instantProgressColor: mainColor.withAlphaComponent(0.5), delayedProgressColor: mainColor)
        
        delayedProgressBar.configure(colorSet: colorSet, roundedCorners: true, animationTime: 0.5)
        
        secondDelayedProgressBar.configureAndAnimate(colorSet: colorSet, roundedCorners: true, animationTime: 0.45, animationDelay: 2, previousProgress: 0.35, currentProgress: 0.7)
        
        delayedGlowingProgress.configureGlowing(colorSet: colorSet, roundedCorners: true, previousProgress: 0.25, currentProgress: 0.5, animationDelay: 0.5)
    }
    
    
    
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
