//
//  KindKit
//

public enum LineJoin {
    
    case miter(Double)
    case bevel
    case round
    
}

extension LineJoin : Hashable {
}

extension LineJoin : Equatable {
}

extension LineJoin : Sendable {
}

public extension LineJoin {
    
    @inlinable
    var miterLimit: Double? {
        switch self {
        case .miter(let limit): return limit
        default: return nil
        }
    }
    
}
