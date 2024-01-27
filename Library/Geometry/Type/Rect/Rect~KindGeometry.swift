//
//  KindKit
//

import KindNumeric

extension Rect : AreaTrait {
    
    @inlinable
    public var area: Coordinate {
        return self.size.area
    }
    
}

extension Rect : PerimeterTrait {
    
    @inlinable
    public var perimeter: Coordinate {
        return self.width.doubled() + self.height.doubled()
    }
    
}

extension Rect : InsetTrait {
    
    @inlinable
    public func inset(_ inset: Inset) -> Self {
        return .init(
            x: self.x + inset.left,
            y: self.y + inset.top,
            size: self.size.inset(inset)
        )
    }
    
}

extension Rect : AspectTrait {
    
    @inlinable
    public var aspectRatio: Coordinate {
        return self.size.aspectRatio
    }
    
}
