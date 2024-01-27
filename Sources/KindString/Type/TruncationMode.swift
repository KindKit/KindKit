//
//  KindKit
//

import Foundation

public enum TruncationMode {
    
    case leading
    case middle
    case trailing
    
}

public extension TruncationMode {
    
    @inlinable
    func apply(_ string: String, limit: Int, leader: String = "...") -> String {
        guard string.count > limit else {
            return string
        }
        switch self {
        case .leading:
            return leader + string.suffix(limit)
        case .middle:
            let prefix = Int(ceil(Float(limit - leader.count) / 2.0))
            let suffix = Int(floor(Float(limit - leader.count) / 2.0))
            return "\(string.prefix(prefix))\(leader)\(string.suffix(suffix))"
        case .trailing:
            return string.prefix(limit) + leader
        }
    }
    
}
