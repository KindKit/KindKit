//
//  KindKit
//

import Foundation

public extension Field {
    
    enum Policy : Equatable {
        
        case all
        case range(Int?, Int?)

    }
    
}

public extension Field.Policy {

    static var one: Self {
        return .range(1, 1)
    }

    static var any: Self {
        return .range(1, nil)
    }

    static func min(_ count: Int) -> Self {
        return .range(count, nil)
    }

    static func max(_ count: Int) -> Self {
        return .range(nil, count)
    }

}

public extension Field.Policy {
    
    var min: Int? {
        switch self {
        case .all: return nil
        case .range(let limit, _): return limit
        }
    }

    var max: Int? {
        switch self {
        case .all: return nil
        case .range(_, let limit): return limit
        }
    }

}

public extension Field.Policy {
    
    func check(
        valid: Int,
        count: Int
    ) -> Bool {
        switch self {
        case .range(let min, let max):
            if let min = min, let max = max {
                return valid >= min && valid <= max
            } else if let min = min {
                return valid >= min
            } else if let max = max {
                return valid <= max
            }
        case .all:
            return valid == count
        }
        return false
    }
    
}
