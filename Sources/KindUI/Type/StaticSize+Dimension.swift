//
//  KindKit
//

import KindMath

public extension StaticSize {

    enum Dimension : Comparable {
        
        case parent(Percent)
        case ratio(Percent)
        case fixed(Double)
        
    }
    
}

public extension StaticSize.Dimension {
    
    static var fill: Self {
        return .parent(.one)
    }
    
    static func parent(_ value: Double) -> Self {
        return .parent(Percent(value))
    }
    
    static func ratio(_ value: Double) -> Self {
        return .ratio(Percent(value))
    }
    
}
