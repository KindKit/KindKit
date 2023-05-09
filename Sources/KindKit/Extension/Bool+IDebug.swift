//
//  KindKit
//

import Foundation

extension Bool : IDebug {
    
    public func debugInfo() -> Debug.Info {
        switch self {
        case false: return .string("false")
        case true: return .string("true")
        }
    }

}
