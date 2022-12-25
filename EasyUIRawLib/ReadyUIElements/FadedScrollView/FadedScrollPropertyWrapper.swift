//
//  FadedScrollPropertyWrapper.swift
//  EasyUIRawLib
//
//  Created by test on 25.12.2022.
//

import UIKit

@propertyWrapper
class FadedScroll<T> where T: UIScrollView {
    
    private var value: T
    
    init(wrappedValue: T) {
        self.value = wrappedValue
    }
    
    var wrappedValue: T {
        get {
            return value
        }
        set {
            self.value = newValue
        }
    }
    
}
