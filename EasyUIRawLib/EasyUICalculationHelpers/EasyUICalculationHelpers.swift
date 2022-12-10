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
    public static func logarythmicBasedDependence(progress: Double, base: Double, interpolation: Interpolation) -> Double {
        if interpolation == .logarithmic {
            let progressRemapped = remap(value: progress, from1: 0, to1: 1, from2: 1, to2: 10)
            return clamp(value: logC(val: progressRemapped, forBase: base), min: 0, max: 1)
        } else if interpolation == .exponentioal {
            let progressReversed = remap(value: (1 - progress), from1: 0, to1: 1, from2: 1, to2: 10)
            return clamp(value: 1 - (logC(val: progressReversed, forBase: base)), min: 0, max: 1)
        }
        return progress
    }
    
    public static func clamp(value: Double, min minVal: Double, max maxVal: Double) -> Double {
        return max(minVal, min(maxVal, value))
    }
    
    public static func logC(val: Double, forBase base: Double) -> Double {
        return log(val)/log(base)
    }
}
