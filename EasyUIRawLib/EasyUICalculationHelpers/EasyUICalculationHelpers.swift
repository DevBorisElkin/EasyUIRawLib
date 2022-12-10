//
//  EasyUICalculationHelpers.swift
//  EasyUIRawLib
//
//  Created by test on 10.12.2022.
//

import Foundation

open class EasyUICalculationHelpers {
    public static func remap(value: Double, from1: Double, to1: Double, from2: Double, to2: Double) -> Double {
        return (value - from1) / (to1 - from1) * (to2 - from2) + from2
    }
    
    public enum Interpolation { case linear, logarithmic, exponentioal}
    
    public static func logarythmicDependence(progress: Double, interpolation: Interpolation) -> Double {
        if interpolation == .logarithmic {
            let progressRemapped = remap(value: progress, from1: 0, to1: 1, from2: 1, to2: 10)
            return log10(progressRemapped)
        } else if interpolation == .exponentioal {
            let progressReversed = remap(value: (1 - progress), from1: 0, to1: 1, from2: 1, to2: 10)
            return 1 - (log10(progressReversed))
        }
        return progress
    }
}
