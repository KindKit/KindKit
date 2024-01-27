//
//  KindKit
//

extension Bool : DebugTrait {
    
    public func buildInfo() -> Info {
        switch self {
        case false: return StringInfo("false")
        case true: return StringInfo("true")
        }
    }

}
