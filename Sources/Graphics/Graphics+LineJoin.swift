//
//  KindKit
//

import Foundation

public extension Graphics {

    enum LineJoin : Equatable {
        
        case miter(Double)
        case bevel
        case round
        
    }

}

public extension Graphics.LineJoin {
    
    @inlinable
    var miterLimit: Double? {
        switch self {
        case .miter(let limit): return limit
        default: return nil
        }
    }
    
}
