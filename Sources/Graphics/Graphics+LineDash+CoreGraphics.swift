//
//  KindKit
//

#if canImport(CoreGraphics)

import CoreGraphics

public extension Graphics.LineJoin {
    
    @inlinable
    var cgLineJoin: CGLineJoin {
        switch self {
        case .miter: return .miter
        case .bevel: return .bevel
        case .round: return .round
        }
    }
    
}

#endif
