//
//  KindKit
//

import KindGeometry

public extension DynamicSize {

    enum Axis : Equatable {
        
        case fixed(Coordinate)
        case fill
        case fit
        
    }
    
}

public extension DynamicSize.Axis {
    
    static var none: Self {
        return .fixed(0)
    }
    
}

public extension DynamicSize.Axis {
    
    var isStatic: Bool {
        switch self {
        case .fixed, .fill: return true
        case .fit: return false
        }
    }
    
}

extension DynamicSize.Axis : MapTrait {
}
