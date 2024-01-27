//
//  KindKit
//

import KindMath

public extension StaticSize {

    enum Axis : Comparable {
        
        case fixed(Double)
        case ratio(Double)
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

extension StaticSize.Axis : IMapable {
}
