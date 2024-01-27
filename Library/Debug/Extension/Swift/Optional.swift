//
//  KindKit
//

extension Optional : DebugTrait where Wrapped : DebugTrait {
    
    public func buildInfo() -> Info {
        switch self {
        case .some(let value): return value.buildInfo()
        case .none: return StringInfo("nil")
        }
    }

}
