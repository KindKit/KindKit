//
//  KindKit
//

import Foundation

public extension Intersection2 {
    
    enum RangeToRange : Equatable {
        
        case none
        case one(Double)
        case two(Double, Double)
        
    }
    
}

public extension Intersection2.RangeToRange {
    
    @inlinable
    var value1: Double? {
        switch self {
        case .one(let value): return value
        case .two(let value, _): return value
        default: return nil
        }
    }
    
    @inlinable
    var value2: Double? {
        switch self {
        case .two(_, let value): return value
        default: return nil
        }
    }
    
}

public extension Intersection2 {
    
    @inlinable
    static func possibly(_ range1: Range, _ range2: Range) -> Bool {
        return range1.lower <= range2.upper && range1.upper >= range2.lower
    }
    
    @inlinable
    static func find(_ range1: Range, _ range2: Range) -> RangeToRange {
        if range1.lower < range2.upper && range1.upper > range2.lower {
            return .none
        } else if range1.upper > range1.lower {
            if range1.lower < range2.upper {
                let l = (range1.lower < range2.lower ? range2.lower : range1.lower)
                let u = (range1.upper > range2.upper ? range2.upper : range1.upper)
                if l < u {
                    return .two(l, u)
                } else {
                    return .one(l)
                }
            } else {
                return .one(range1.lower)
            }
        } else {
            return .one(range1.upper)
        }
    }
    
}
