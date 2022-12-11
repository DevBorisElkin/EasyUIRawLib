//
//  Example_1_ScrollView.swift
//  EasyUIRawLib
//
//  Created by test on 05.12.2022.
//

import UIKit

class Example_1_ScrollView: UIView {
    @IBOutlet weak var parentForFadedScrollView_1: UIView!
    @IBOutlet weak var parentForFadedScrollView_2: UIView!
    @IBOutlet weak var parentForFadedScrollView_3: UIView!
    
    override func awakeFromNib() {
        createFirst()
        createSecond()
    }
    
    func createFirst() {
        let fadedScrollView_1 = FadedScrollView()
        fadedScrollView_1.translatesAutoresizingMaskIntoConstraints = false
        
        parentForFadedScrollView_1.addSubview(fadedScrollView_1)
        NSLayoutConstraint.activate([
            fadedScrollView_1.topAnchor.constraint(equalTo: parentForFadedScrollView_1.topAnchor),
            fadedScrollView_1.leadingAnchor.constraint(equalTo: parentForFadedScrollView_1.leadingAnchor),
            fadedScrollView_1.trailingAnchor.constraint(equalTo: parentForFadedScrollView_1.trailingAnchor),
            fadedScrollView_1.bottomAnchor.constraint(equalTo: parentForFadedScrollView_1.bottomAnchor)
        ])
        
        let contentStackView = UIStackView()
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        
        for i in 1...10 {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .red
            view.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            contentStackView.addArrangedSubview(view)
        }
        
        fadedScrollView_1.addSubview(contentStackView)
        contentStackView.topAnchor.constraint(equalTo: fadedScrollView_1.topAnchor).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: fadedScrollView_1.leadingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: fadedScrollView_1.trailingAnchor).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: fadedScrollView_1.bottomAnchor).isActive = true
        
        contentStackView.leadingAnchor.constraint(equalTo: fadedScrollView_1.frameLayoutGuide.leadingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: fadedScrollView_1.frameLayoutGuide.trailingAnchor).isActive = true
        contentStackView.topAnchor.constraint(equalTo: fadedScrollView_1.contentLayoutGuide.topAnchor).isActive = true
        contentStackView.heightAnchor.constraint(equalTo: fadedScrollView_1.contentLayoutGuide.heightAnchor).isActive = true
        
        fadedScrollView_1.configureLogarithmic(startFadeSize: 0.3, endFadeSize: 0.1)
    }
    
    var secondFadedScrollView: FadedScrollView?
    var contentStackView: UIStackView?
    
    func createSecond() {
        let fadedScrollView_1 = FadedScrollView()
        fadedScrollView_1.backgroundColor = .brown
        secondFadedScrollView = fadedScrollView_1
        
        fadedScrollView_1.translatesAutoresizingMaskIntoConstraints = false
        //fadedScrollView_1.backgroundColor = .brown
        
        parentForFadedScrollView_2.addSubview(fadedScrollView_1)
        NSLayoutConstraint.activate([
            fadedScrollView_1.topAnchor.constraint(equalTo: parentForFadedScrollView_2.topAnchor),
            fadedScrollView_1.leadingAnchor.constraint(equalTo: parentForFadedScrollView_2.leadingAnchor),
            fadedScrollView_1.trailingAnchor.constraint(equalTo: parentForFadedScrollView_2.trailingAnchor),
            fadedScrollView_1.bottomAnchor.constraint(equalTo: parentForFadedScrollView_2.bottomAnchor)
        ])
        
        //spawnContentForSecondScrollView()
        
        fadedScrollView_1.configure(startFadeSizeMult: 0.25, endFadeSizeMult: 0.5, startProgressToHideFade: 0.05, endProgressToHideFade: 0.05, interpolation: .linear, debugModeEnabled: true, debugProgressLogs: true)
        
        
        
        
    }
    
    private func spawnContentForSecondScrollView() {
        guard let fadedScrollView_1 = secondFadedScrollView else { return }
        let contentStackView = UIStackView()
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.spacing = 0
        
        for i in 1...50 {
            let view = UILabel()
            view.text = "Hello There!"
            view.translatesAutoresizingMaskIntoConstraints = false
            //view.backgroundColor = .red
            view.textColor = .black
            //view.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            contentStackView.addArrangedSubview(view)
        }
        
        fadedScrollView_1.addSubview(contentStackView)
        contentStackView.topAnchor.constraint(equalTo: fadedScrollView_1.topAnchor).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: fadedScrollView_1.leadingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: fadedScrollView_1.trailingAnchor).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: fadedScrollView_1.bottomAnchor).isActive = true
        
        contentStackView.leadingAnchor.constraint(equalTo: fadedScrollView_1.frameLayoutGuide.leadingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: fadedScrollView_1.frameLayoutGuide.trailingAnchor).isActive = true
        contentStackView.topAnchor.constraint(equalTo: fadedScrollView_1.contentLayoutGuide.topAnchor).isActive = true
        contentStackView.heightAnchor.constraint(equalTo: fadedScrollView_1.contentLayoutGuide.heightAnchor).isActive = true
    }
    
    @IBAction func clearContent() {
        if let secondFadedScrollView = secondFadedScrollView {
            for view in secondFadedScrollView.subviews {
                // is this necessary
                NSLayoutConstraint.deactivate(view.constraints)
                view.removeFromSuperview()
            }
        }
        //secondFadedScrollView?.onContentSizeChanged()
    }
    
    @IBAction func spawnContent() {
        spawnContentForSecondScrollView()
    }
    
    @IBAction func spawnStackViewToContent() {
        guard let fadedScrollView_1 = secondFadedScrollView else { return }
        let contentStackView = UIStackView()
        self.contentStackView = contentStackView
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.spacing = 0
        
        fadedScrollView_1.addSubview(contentStackView)
        contentStackView.topAnchor.constraint(equalTo: fadedScrollView_1.topAnchor).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: fadedScrollView_1.leadingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: fadedScrollView_1.trailingAnchor).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: fadedScrollView_1.bottomAnchor).isActive = true
        
        contentStackView.leadingAnchor.constraint(equalTo: fadedScrollView_1.frameLayoutGuide.leadingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: fadedScrollView_1.frameLayoutGuide.trailingAnchor).isActive = true
        contentStackView.topAnchor.constraint(equalTo: fadedScrollView_1.contentLayoutGuide.topAnchor).isActive = true
        contentStackView.heightAnchor.constraint(equalTo: fadedScrollView_1.contentLayoutGuide.heightAnchor).isActive = true
    }
    
    @IBAction func spawnItemToStackView() {
        guard let contentStackView = contentStackView else { return }
        
        let view = UILabel()
        view.text = "Hello There!"
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = .red
        view.textColor = .black
        //view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        contentStackView.addArrangedSubview(view)
    }
    
    @IBAction func removeLastItemFromStackView() {
        guard let contentStackView = contentStackView else { return }
        if let last = contentStackView.arrangedSubviews.last {
            last.removeFromSuperview()
        }
    }
}
