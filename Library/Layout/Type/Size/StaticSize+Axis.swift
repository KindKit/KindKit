//
//  KindKit
//

import KindGeometry

public extension StaticSize {

    enum Axis : Comparable {
        
        case fixed(Coordinate)
        case ratio(Coordinate)
        case fill
        
    }
    
}

public extension StaticSize.Axis {
    
    static var none: Self {
        return .fixed(0)
    }
    
    @inlinable
    static func ratio(_ value: Percent) -> Self {
        return .ratio(value.value)
    }
    
}

extension StaticSize.Axis : MapTrait {
}
