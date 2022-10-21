//
//  KindKit
//

import Foundation

public extension UI.Size.Static {

    enum Dimension : Equatable {
        
        case fill
        case percent(PercentFloat)
        case fixed(Float)
        
    }
    
}

public extension UI.Size.Static.Dimension {
    
    @inlinable
    func apply(
        available: Float
    ) -> Float {
        switch self {
        case .fill:
            guard available.isInfinite == false else { return 0 }
            return max(0, available)
        case .fixed(let value):
            return max(0, value)
        case .percent(let value):
            guard available.isInfinite == false else { return 0 }
            return max(0, available * value.value)
        }
    }
    
}
