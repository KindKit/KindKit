//
//  KindKitGraphics
//

#if canImport(CoreGraphics)

import CoreGraphics

public extension GraphicsLineJoin {
    
    var cgLineJoin: CGLineJoin {
        switch self {
        case .miter: return .miter
        case .bevel: return .bevel
        case .round: return .round
        }
    }
    
}

#endif
