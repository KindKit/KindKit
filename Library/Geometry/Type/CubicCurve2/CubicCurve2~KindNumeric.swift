//
//  KindKit
//

import KindNumeric

extension CubicCurve2 : AddTrait {
    
    @inlinable
    public func adding(on other: Self) -> Self {
        return .init(
            start: self.start.adding(on: other.start),
            control1: self.control1.adding(on: other.control1),
            control2: self.control2.adding(on: other.control2),
            end: self.end.adding(on: other.end)
        )
    }
    
}

extension CubicCurve2 : SubTrait {
    
    @inlinable
    public func subtracting(this other: Self) -> Self {
        return .init(
            start: self.start.subtracting(this: other.start),
            control1: self.control1.subtracting(this: other.control1),
            control2: self.control2.subtracting(this: other.control2),
            end: self.end.subtracting(this: other.end)
        )
    }
    
}

extension CubicCurve2 : LerpTrait {
    
    @inlinable
    public func lerp(_ to: Self, by progress: Percent) -> Self {
        return .init(
            start: self.start.lerp(to.start, by: progress),
            control1: self.control1.lerp(to.control1, by: progress),
            control2: self.control2.lerp(to.control2, by: progress),
            end: self.end.lerp(to.end, by: progress)
        )
    }
    
}

