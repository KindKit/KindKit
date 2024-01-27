//
//  KindKit
//

import KindNumeric

public protocol RotatedAroundPointTrait {
        
    func rotated(by matrix: Matrix3, around: Point) -> Self
    
}

public extension RotatedAroundPointTrait {
    
    @inlinable
    func rotated(by matrix: Matrix3) -> Self {
        return self.rotated(by: matrix, around: .zero)
    }
    
    @inlinable
    func rotated(by angle: Radian, around: Point) -> Self {
        return self.rotated(by: .init(rotation: angle), around: around)
    }
    
    @inlinable
    func rotated(by angle: Radian) -> Self {
        return self.rotated(by: angle, around: .zero)
    }
    
}
