//
//  KindKitMath
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

infix operator ~~ : ComparisonPrecedence
infix operator !~ : ComparisonPrecedence

public protocol INearEqutable {
    
    static func ~~ (lhs: Self, rhs: Self) -> Bool
    static func !~ (lhs: Self, rhs: Self) -> Bool
    
}

public extension INearEqutable {
    
    @inlinable
    static func !~ (lhs: Self, rhs: Self) -> Bool {
        return (lhs ~~ rhs) == false
    }
    
}

public extension INearEqutable where Self : IScalar {
    
    @inlinable
    static func ~~ (lhs: Self, rhs: Self) -> Bool {
        let d = lhs - rhs
        return d.abs <= Self.epsilon
    }
    
}
