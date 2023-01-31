//
//  Example_6_CooldownClickButton.swift
//  EasyUIRawLib
//
//  Created by test on 31.01.2023.
//

import UIKit

class Example_6_CooldownClickButton: UIViewController {
    
    @IBOutlet weak var firstButton: UIButton!
    
    
    @IBOutlet weak var secondButton: UIButton!
    
    
    override func viewDidLoad() {
        secondButton.addTarget(self, action: #selector(secondButtonTapped), for: .touchUpInside)
    }
    
    @IBAction private func firstButtonTapped(_ sender: Any?) {
        guard firstButton.checkTapDelay(delay: 0.25) else { return }
        print("Boom 1")
    }
    
    @objc private func secondButtonTapped(_ sender: Any?) {
        guard secondButton.checkTapDelay(delay: 2.0) else { return }
        print("Boom 2")
    }
}
