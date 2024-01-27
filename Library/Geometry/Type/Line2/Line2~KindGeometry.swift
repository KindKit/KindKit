//
//  KindKit
//

import KindNumeric

extension Line2 : AddPointTrait {
    
    @inlinable
    public func adding(on point: Point) -> Self {
        return .init(
            origin: self.origin.adding(on: point),
            direction: self.direction
        )
    }
    
}

extension Line2 : SubPointTrait {
    
    @inlinable
    public func subtracting(this point: Point) -> Self {
        return .init(
            origin: self.origin.subtracting(this: point),
            direction: self.direction
        )
    }
    
}

extension Line2 : RotatedAroundPointTrait {
    
    @inlinable
    public func rotated(by matrix: Matrix3, around: Point) -> Self {
        return .init(
            origin: self.origin.rotated(by: matrix, around: around),
            direction: self.direction.rotated(by: matrix)
        )
    }
    
}
