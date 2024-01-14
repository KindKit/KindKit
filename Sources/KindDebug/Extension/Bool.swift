//
//  KindKit
//

extension Bool : IEntity {
    
    public func debugInfo() -> Info {
        switch self {
        case false: return .string("false")
        case true: return .string("true")
        }
    }

}
