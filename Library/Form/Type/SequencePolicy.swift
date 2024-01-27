//
//  KindKit
//

public enum SequencePolicy : Equatable {
    
    case all
    case range(Int?, Int?)
    
}

public extension SequencePolicy {

    @inlinable
    static var one: Self {
        return .range(1, 1)
    }

    @inlinable
    static var any: Self {
        return .range(1, nil)
    }

    @inlinable
    static func min(_ count: Int) -> Self {
        return .range(count, nil)
    }

    @inlinable
    static func max(_ count: Int) -> Self {
        return .range(nil, count)
    }

}

public extension SequencePolicy {
    
    @inlinable
    var min: Int? {
        switch self {
        case .all: return nil
        case .range(let limit, _): return limit
        }
    }

    @inlinable
    var max: Int? {
        switch self {
        case .all: return nil
        case .range(_, let limit): return limit
        }
    }

}

public extension SequencePolicy {
    
    func check(
        fields: [any Field]
    ) -> Bool {
        return self.check(
            valid: fields.kk_count(where: { $0.isValid }),
            count: fields.count
        )
    }
    
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
