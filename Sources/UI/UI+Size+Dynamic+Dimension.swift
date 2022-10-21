//
//  KindKit
//

import Foundation

public extension UI.Size.Dynamic {

    enum Dimension : Equatable {
        
        case fill
        case percent(PercentFloat)
        case fixed(Float)
        case morph(PercentFloat)
        case fit
        
    }
    
}

public extension UI.Size.Dynamic.Dimension {
    
    var isStatic: Bool {
        switch self {
        case .fill, .percent, .fixed: return true
        case .morph, .fit: return false
        }
    }
    
}

public extension UI.Size.Dynamic.Dimension {
    
    @inlinable
    func apply(
        available: Float,
        calculate: () -> Float
    ) -> Float? {
        switch self {
        case .fill:
            guard available.isInfinite == false else { return 0 }
            return max(0, available)
        case .percent(let value):
            guard available.isInfinite == false else { return 0 }
            return max(0, available * value.value)
        case .fixed(let value):
            return max(0, value)
        case .morph(let percent):
            let r = calculate()
            guard r.isInfinite == false else { return nil }
            return max(0, r * percent.value)
        case .fit:
            let r = calculate()
            guard r.isInfinite == false else { return nil }
            return max(0, r)
        }
    }
    
}
