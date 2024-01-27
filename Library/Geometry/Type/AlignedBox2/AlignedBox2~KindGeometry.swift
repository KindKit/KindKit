//
//  KindKit
//

import KindNumeric

extension AlignedBox2 : AspectTrait {
    
    @inlinable
    public var aspectRatio: Coordinate {
        return self.size.aspectRatio
    }
    
}

extension AlignedBox2 : AreaTrait {
    
    @inlinable
    public var area: Coordinate {
        return self.width * self.height
    }
    
}

extension AlignedBox2 : PerimeterTrait {
    
    @inlinable
    public var perimeter: Coordinate {
        return self.width.doubled() + self.height.doubled()
    }
    
}

extension AlignedBox2 : InsetTrait {
    
    @inlinable
    public func inset(_ inset: Inset) -> Self {
        return .init(
            lower: .init(
                x: self.lower.x + inset.left,
                y: self.lower.y + inset.top
            ),
            upper: .init(
                x: self.upper.x - inset.right,
                y: self.upper.y - inset.bottom
            )
        )
    }
    
}

extension AlignedBox2 : RotatedAroundPointTrait {

    @inlinable
    public func rotated(by matrix: Matrix3, around: Point) -> Self {
        return .init([
            self.topLeft.rotated(by: matrix, around: around),
            self.topRight.rotated(by: matrix, around: around),
            self.bottomLeft.rotated(by: matrix, around: around),
            self.bottomRight.rotated(by: matrix, around: around)
        ])
    }

}

extension AlignedBox2 : MulMatrix3Trait {

    @inlinable
    public func multiplying(by matrix: Matrix3) -> Self {
        return .init([
            self.topLeft.multiplying(by: matrix),
            self.topRight.multiplying(by: matrix),
            self.bottomLeft.multiplying(by: matrix),
            self.bottomRight.multiplying(by: matrix)
        ])
    }

}
