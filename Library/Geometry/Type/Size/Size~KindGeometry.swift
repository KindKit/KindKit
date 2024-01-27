//
//  KindKit
//

import KindNumeric

extension Size : AreaTrait {
    
    @inlinable
    public var area: Coordinate {
        return self.width * self.height
    }
    
}

extension Size : InsetTrait {
    
    @inlinable
    public func inset(_ inset: Inset) -> Self {
        return self.inset(
            horizontal: inset.horizontal,
            vertical: inset.vertical
        )
    }
    
}

extension Size : AspectTrait {
    
    @inlinable
    public var aspectRatio: Coordinate {
        return self.width / self.height
    }
    
}
