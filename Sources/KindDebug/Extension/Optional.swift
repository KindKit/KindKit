//
//  KindKit
//

extension Optional : IEntity {
    
    public func debugInfo() -> Info {
        switch self {
        case .some(let value): return .cast(value)
        case .none: return .string("nil")
        }
    }

}
