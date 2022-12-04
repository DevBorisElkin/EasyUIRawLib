//
//  RoutingButton.swift
//  EasyUIRawLib
//
//  Created by test on 04.12.2022.
//

import UIKit

class RoutingButton: UIButton {
    @IBInspectable var storyboard: String = ""
    @IBInspectable var controllerId: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @objc private func buttonClicked(_ sender: Any?) {
        let sb = UIStoryboard(name: storyboard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: controllerId)
        self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
