//
//  KindKit
//

import KindNumeric

extension Segment2 : AddTrait {
    
    @inlinable
    public func adding(on other: Self) -> Self {
        return .init(
            start: self.start.adding(on: other.start),
            end: self.end.adding(on: other.end)
        )
    }
    
}

extension Segment2 : SubTrait {
    
    @inlinable
    public func subtracting(this other: Self) -> Self {
        return .init(
            start: self.start.subtracting(this: other.start),
            end: self.end.subtracting(this: other.end)
        )
    }
    
}

extension Segment2 : LerpTrait {
    
    @inlinable
    public func lerp(_ to: Self, by progress: Percent) -> Self {
        return .init(
            start: self.start.lerp(to.start, by: progress),
            end: self.end.lerp(to.end, by: progress)
        )
    }
    
}

