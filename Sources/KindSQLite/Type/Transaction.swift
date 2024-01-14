//
//  KindKit
//

public enum Transaction {
    
    case deferred
    case immediate
    case exclusive
    
}

extension Transaction : IExpressable {
    
    public var query: String {
        switch self {
        case .deferred: return "DEFERRED"
        case .immediate: return "IMMEDIATE"
        case .exclusive: return "EXCLUSIVE"
        }
    }
    
}
