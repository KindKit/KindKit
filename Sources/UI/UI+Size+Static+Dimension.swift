//
//  KindKit
//

import Foundation

public extension UI.Size.Static {

    enum Dimension : Comparable {
        
        case parent(Percent)
        case ratio(Percent)
        case fixed(Double)
        
    }
    
}

public extension UI.Size.Static.Dimension {
    
    static var fill: Self {
        return .parent(.one)
    }
    
    @available(*, deprecated, renamed: "UI.Size.Static.Dimension.parent")
    static func percent(_ value: Percent) -> Self {
        return .parent(value)
    }
    
}
