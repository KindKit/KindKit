//
//  KindKit
//

#if canImport(CoreGraphics)

import CoreGraphics

public extension Graphics.LineCap {
    
    var cgLineCap: CGLineCap {
        switch self {
        case .butt: return .butt
        case .square: return .square
        case .round: return .round
        }
    }
    
}

#endif
