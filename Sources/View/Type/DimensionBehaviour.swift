//
//  KindKitCore
//

import Foundation

public enum DimensionBehaviour : Equatable {
    case fixed(_ value: Float)
    case percent(_ value: Float)
    case fill
}

public extension DimensionBehaviour {
    
    @inlinable
    func value(_ available: Float) -> Float? {
        switch self {
        case .fixed(let value):
            return max(0, value)
        case .percent(let value):
            guard available.isInfinite == false else { return nil }
            return max(0, available * value)
        case .fill:
            guard available.isInfinite == false else { return nil }
            return max(0, available)
        }
    }
    
}
