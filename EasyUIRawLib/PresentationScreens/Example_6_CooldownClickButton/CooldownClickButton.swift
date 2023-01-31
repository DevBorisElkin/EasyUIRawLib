//
//  CooldownClickButton.swift
//  EasyUIRawLib
//
//  Created by test on 31.01.2023.
//

import UIKit

extension UIButton {
    private static var _lastTimeClickedStorage = [String:Date]()
    
    private var lastTapOccoured: Date? {
        get {
            let address = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return UIButton._lastTimeClickedStorage[address]
        }
        set(newValue) {
            let address = String(format: "%p", unsafeBitCast(self, to: Int.self))
            UIButton._lastTimeClickedStorage[address] = newValue
        }
    }
    
    /// returns 'true' if tap can be performed, if 'delay' is equal or less then zero performs no checks and returns 'true'. Each successful call of this method (that returned 'true') will schedule next allowed tap.
    func checkTapDelay(delay: Double) -> Bool {
        guard delay > 0 else { return true }
        
        if self.lastTapOccoured != nil && toSeconds(timeInterval: Date().timeIntervalSince(lastTapOccoured!)) < delay {
            print("Tap filtered out, wait for \(delay) seconds to pass from the last registered tap.")
            return false
        }
        lastTapOccoured = Date()
        return true
    }
    
    private func toSeconds(timeInterval: TimeInterval) -> Double {
        return Double(Int(timeInterval * 1_000)) / 1000
    }
}
