//
//  KindKit
//

extension INearEqutable where Self : FloatingPoint {
    
    @inlinable
    public static func ~~ (lhs: Self, rhs: Self) -> Bool {
        let d = lhs - rhs
        if d > .leastNonzeroMagnitude {
            return d <= .ulpOfOne
        }
        return -d <= .ulpOfOne
    }

}

extension Float : INearEqutable {
}

extension Double : INearEqutable {
}
