//
//  Example_5_ScalingDownByTransform.swift
//  EasyUIRawLib
//
//  Created by test on 16.01.2023.
//

import UIKit

class Example_5_ScalingDownByTransform: UIViewController {
    
    @IBOutlet weak var stackToInsertInto: UIStackView!
    
    @IBOutlet weak var viewToScale_1: UIView!
    @IBOutlet weak var viewToScale_2: UIView!
    
    @IBOutlet weak var scalableWrapperView_1: ScalableWrapperView!
    
    override func viewDidLoad() {
        //viewToScale_1.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        //viewToScale_2.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        //scalableWrapperView_1.changeHeight2(scale: 0.5)
        
        let scalableWrapperView = ScalableWrapperView()
        let rowView = createRowView()
        rowView.backgroundColor = .red
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            scalableWrapperView.configure(flexibleSubview: rowView, parent: self.stackToInsertInto, emplacement: .arrange(at: 1), mainParentToLayoutSubviews: self.view)
            scalableWrapperView.squashAndChangeScale(scale: 1, animationTime: 0.5, zPositionChange: -10)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                //scalableWrapperView.configure(flexibleSubview: rowView, parent: self.stackToInsertInto, emplacement: .arrange(at: 1), mainParentToLayoutSubviews: self.view)
                scalableWrapperView.squashHeight(scale: 0.01, animationTime: 0.5)
            }
        }
        
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
//            //scalableWrapperView.changeScale(newScale: 0.01, animationTime: 0.35)
//            scalableWrapperView.squashHeight(scale: 0.01, animationTime: 1, zPositionChange: -10)
//        }
    }
    
    private func createRowView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.heightAnchor.constraint(equalToConstant: 37).isActive = true
        view.widthAnchor.constraint(equalToConstant: 324).isActive = true
        
        let viewLabel = UILabel()
        viewLabel.translatesAutoresizingMaskIntoConstraints = false
        viewLabel.text = "Hi There Some Label"
        viewLabel.font = UIFont.systemFont(ofSize: 17)
        
        view.addSubview(viewLabel)
        viewLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        viewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        
        return view
    }
}
