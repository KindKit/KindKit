//
//  KindKitGraphics
//

#if canImport(CoreGraphics)

import CoreGraphics

public extension GraphicsLineCap {
    
    var cgLineCap: CGLineCap {
        switch self {
        case .butt: return .butt
        case .square: return .square
        case .round: return .round
        }
    }
    
}

#endif
