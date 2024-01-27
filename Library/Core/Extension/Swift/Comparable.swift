//
//  KindKit
//

public extension Comparable {
    
    @inlinable
    func isLess(_ other: Self) -> Bool {
        return self < other
    }
    
    @inlinable
    func isMore(_ other: Self) -> Bool {
        return self > other
    }
    
    @inlinable
    func isLessOrEqual(_ other: Self) -> Bool {
        return self <= other
    }
    
    @inlinable
    func isMoreOrEqual(_ other: Self) -> Bool {
        return self >= other
    }
    
    @inlinable
    func min(_ other: Self) -> Self {
        if self.isLess(other) {
            return self
        }
        return other
    }
    
    @inlinable
    func min(_ other: Self, _ rest: Self ...) -> Self {
        return rest.reduce(self.min(other), { $0.min($1) })
    }
    
    @inlinable
    func max(_ other: Self) -> Self {
        if self.isMore(other) {
            return self
        }
        return other
    }
    
    @inlinable
    func max(_ other: Self, _ rest: Self ...) -> Self {
        return rest.reduce(self.max(other), { $0.max($1) })
    }
    
    @inlinable
    func isWithin(_ lower: Self, _ upper: Self) -> Bool {
        return self >= lower && self <= upper
    }
    
    @inlinable
    func clamp(_ lower: Self, _ upper: Self) -> Self {
        if self < lower {
            return lower
        } else if self > upper {
            return upper
        }
        return self
    }
    
}
