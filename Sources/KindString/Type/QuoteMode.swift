//
//  KindKit
//

public enum QuoteMode {
    
    case single
    case double
    
}

public extension QuoteMode {
    
    @inlinable
    var string: String {
        switch self {
        case .single: return "'"
        case .double: return "\""
        }
    }
    
}
