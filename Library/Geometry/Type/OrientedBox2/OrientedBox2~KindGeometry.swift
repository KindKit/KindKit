//
//  KindKit
//

import KindNumeric

extension OrientedBox2 : AreaTrait {
    
    @inlinable
    public var area: Coordinate {
        return self.shape.area
    }
    
}

extension OrientedBox2 : PerimeterTrait {
    
    @inlinable
    public var perimeter: Coordinate {
        return self.shape.perimeter
    }
    
}

extension OrientedBox2 : InsetTrait {
    
    @inlinable
    public func inset(_ inset: Inset) -> Self {
        return .init(
            shape: self.shape.inset(inset),
            angle: self.angle
        )
    }
    
}

extension OrientedBox2 : AspectTrait {
    
    @inlinable
    public var aspectRatio: Coordinate {
        return self.shape.aspectRatio
    }
    
}
