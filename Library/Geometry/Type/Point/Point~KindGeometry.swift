//
//  KindKit
//

import KindNumeric

extension Point : RotatedAroundPointTrait {
    
    @inlinable
    public func rotated(by matrix: Matrix3, around: Point) -> Self {
        let diff = self.subtracting(this: around)
        let rotated = diff.multiplying(by: matrix)
        return around.adding(on: rotated)
    }
    
}

extension Point : MulMatrix3Trait {
    
    @inlinable
    public func multiplying(by matrix: Matrix3) -> Self {
        return .init(
            x: self.x * matrix.m11 + self.y * matrix.m21 + matrix.m31,
            y: self.x * matrix.m12 + self.y * matrix.m22 + matrix.m32
        )
    }
    
}
