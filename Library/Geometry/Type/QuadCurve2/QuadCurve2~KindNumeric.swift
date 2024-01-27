//
//  KindKit
//

import KindNumeric

extension QuadCurve2 : AddTrait {
    
    @inlinable
    public func adding(on other: Self) -> Self {
        return .init(
            start: self.start.adding(on: other.start),
            control: self.control.adding(on: other.control),
            end: self.end.adding(on: other.end)
        )
    }
    
}

extension QuadCurve2 : SubTrait {
    
    @inlinable
    public func subtracting(this other: Self) -> Self {
        return .init(
            start: self.start.subtracting(this: other.start),
            control: self.control.subtracting(this: other.control),
            end: self.end.subtracting(this: other.end)
        )
    }
    
}

extension QuadCurve2 : LerpTrait {
    
    @inlinable
    public func lerp(_ to: Self, by progress: Percent) -> Self {
        return .init(
            start: self.start.lerp(to.start, by: progress),
            control: self.control.lerp(to.control, by: progress),
            end: self.end.lerp(to.end, by: progress)
        )
    }
    
}

