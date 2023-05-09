//
//  KindKit
//

import Foundation

extension Optional : IDebug {
    
    public func debugInfo() -> Debug.Info {
        switch self {
        case .some(let value): return .cast(value)
        case .none: return .string("nil")
        }
    }

}
