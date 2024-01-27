//
//  KindKit
//

import KindNumeric

extension Intersection2 {
        
    public enum RangeToRange : Equatable {
        
        case one(Coordinate)
        case two(Coordinate, Coordinate)
        
        @inlinable
        public var value1: Coordinate {
            switch self {
            case .one(let value): return value
            case .two(let value, _): return value
            }
        }
        
        @inlinable
        public var value2: Coordinate? {
            switch self {
            case .two(_, let value): return value
            default: return nil
            }
        }
        
    }
        
    @inlinable
    public static func possibly(_ range1: Range< Coordinate >, _ range2: Range< Coordinate >) -> Bool {
        return range1.lowerBound <= range2.upperBound && range1.upperBound >= range2.lowerBound
    }
    
    @inlinable
    public static func find(_ range1: Range< Coordinate >, _ range2: Range< Coordinate >) -> RangeToRange? {
        if range1.lowerBound < range2.upperBound && range1.upperBound > range2.lowerBound {
            return nil
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
