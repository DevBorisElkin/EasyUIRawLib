//
//  EasyUICalculationHelpers.swift
//  EasyUIRawLib
//
//  Created by test on 10.12.2022.
//

import Foundation

infix operator ~ : ComparisonPrecedence
class EasyUICalculationHelpers {
    public static func remap(value: Double, from1: Double, to1: Double, from2: Double, to2: Double) -> Double {
        return (value - from1) / (to1 - from1) * (to2 - from2) + from2
    }
    
//    public static func logarythmicDependence(progress: Double, interpolation: Interpolation) -> Double {
//        if interpolation == .logarithmic {
//            let progressRemapped = remap(value: progress, from1: 0, to1: 1, from2: 1, to2: 10)
//            return log10(progressRemapped)
//        } else if interpolation == .exponentioal {
//            let progressReversed = remap(value: (1 - progress), from1: 0, to1: 1, from2: 1, to2: 10)
//            return 1 - (log10(progressReversed))
//        }
//        return progress
//    }
    
    public static func logarythmicBasedDependence(progress: Double, interpolation: FadeInterpolation) -> Double {
        if progress == 0 { return 0 }
        switch interpolation {
        case .linear:
            return progress
        case .logarithmicFromEdges(base: let base):
            let progressReversed = remap(value: (1 - progress), from1: 0, to1: 1, from2: 1, to2: 10)
            return clamp(value: 1 - (logC(val: progressReversed, forBase: base)), min: 0, max: 1)
        case .exponentialFromEdges(base: let base):
            let progressRemapped = remap(value: progress, from1: 0, to1: 1, from2: 1, to2: 10)
            return clamp(value: logC(val: progressRemapped, forBase: base), min: 0, max: 1)
        }
    }
    
    public static func clamp(value: Double, min minVal: Double, max maxVal: Double) -> Double {
        return max(minVal, min(maxVal, value))
    }
    
    public static func logC(val: Double, forBase base: Double) -> Double {
        return log(val)/log(base)
    }
    
    enum FadeInterpolation: Equatable {
        case linear, logarithmicFromEdges(base: Double = 5), exponentialFromEdges(base: Double = 5)
        
        static func == (lhs: FadeInterpolation, rhs: FadeInterpolation) -> Bool {
            switch (lhs, rhs) {
            case (FadeInterpolation.linear, FadeInterpolation.linear): return true
            case (FadeInterpolation.logarithmicFromEdges(let base), FadeInterpolation.logarithmicFromEdges(let base2)) : return base == base2
            case (FadeInterpolation.exponentialFromEdges(let base), FadeInterpolation.exponentialFromEdges(let base2)): return base == base2
            default: return false
            }
        }
        
        static func ~ (lhs: FadeInterpolation, rhs: FadeInterpolation) -> Bool {
            switch (lhs, rhs) {
            case (FadeInterpolation.linear, FadeInterpolation.linear): return true
            case (FadeInterpolation.logarithmicFromEdges(_), FadeInterpolation.logarithmicFromEdges(_)) : return true
            case (FadeInterpolation.exponentialFromEdges(_), FadeInterpolation.exponentialFromEdges(_)): return true
            default: return false
            }
        }
    }
}
