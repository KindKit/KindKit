//
//  KindKit
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

infix operator ~~ : ComparisonPrecedence
infix operator !~ : ComparisonPrecedence
infix operator <~ : ComparisonPrecedence
infix operator >~ : ComparisonPrecedence

public protocol INearEqutable {
    
    static func ~~ (lhs: Self, rhs: Self) -> Bool
    static func !~ (lhs: Self, rhs: Self) -> Bool
    static func <~ (lhs: Self, rhs: Self) -> Bool
    static func >~ (lhs: Self, rhs: Self) -> Bool
    
}

public extension INearEqutable {
    
    @inlinable
    static func !~ (lhs: Self, rhs: Self) -> Bool {
        return (lhs ~~ rhs) == false
    }
    
}

public extension INearEqutable where Self : Comparable {
    
    @inlinable
    static func <~ (lhs: Self, rhs: Self) -> Bool {
        if lhs < rhs {
            return true
        }
        return lhs ~~ rhs
    }

    @inlinable
    static func >~ (lhs: Self, rhs: Self) -> Bool {
        if lhs > rhs {
            return true
        }
        return lhs ~~ rhs
    }
    
}
