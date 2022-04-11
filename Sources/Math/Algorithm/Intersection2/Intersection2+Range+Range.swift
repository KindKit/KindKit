//
//  KindKitMath
//

import Foundation

public extension Intersection2 {
    
    enum RangeToRange : Equatable {
        case none
        case one(ValueType)
        case two(ValueType, ValueType)
    }
    
}

public extension Intersection2.RangeToRange {
    
    @inlinable
    var value1: ValueType? {
        switch self {
        case .one(let value): return value
        case .two(let value, _): return value
        default: return nil
        }
    }
    
    @inlinable
    var value2: ValueType? {
        switch self {
        case .two(_, let value): return value
        default: return nil
        }
    }
    
}

public extension Intersection2 {
    
    @inlinable
    static func possibly(_ range1: RangeType, _ range2: RangeType) -> Bool {
        return range1.lowerBound <= range2.upperBound && range1.upperBound >= range2.lowerBound
    }
    
    @inlinable
    static func find(_ range1: RangeType, _ range2: RangeType) -> RangeToRange {
        if range1.lowerBound < range2.upperBound && range1.upperBound > range2.lowerBound {
            return .none
        } else if range1.upperBound > range1.lowerBound {
            if range1.lowerBound < range2.upperBound {
                let l = (range1.lowerBound < range2.lowerBound ? range2.lowerBound : range1.lowerBound)
                let u = (range1.upperBound > range2.upperBound ? range2.upperBound : range1.upperBound)
                if l < u {
                    return .two(l, u)
                } else {
                    return .one(l)
                }
            } else {
                return .one(range1.lowerBound)
            }
        } else {
            return .one(range1.upperBound)
        }
    }
    
}
