//
//  KindKit
//

import KindCore

public struct RangeValidator< Limit : Comparable & Sendable > : Validator {
    
    public let lower: Limit?
    public let upper: Limit?
    
    public init(lower: Limit) {
        self.lower = lower
        self.upper = nil
    }
    
    public init(upper: Limit) {
        self.lower = nil
        self.upper = upper
    }
    
    public init(lower: Limit, upper: Limit) {
        self.lower = lower
        self.upper = upper
    }
    
    public func validate(value: Limit) -> Error? {
        if let limit = self.lower {
            if value < limit {
                return .lessThan(limit: limit)
            }
        }
        if let limit = self.upper {
            if value > limit {
                return .moreThan(limit: limit)
            }
        }
        return nil
    }
    
    public func isEqual(_ other: Self) -> Bool {
        return self.lower == other.lower && self.upper == other.upper
    }
    
}

public extension InputField {
    
    @inlinable
    convenience init< Value : Comparable & Sendable >(
        scope: Scope,
        id: Id,
        value: Value,
        lower: Value
    ) where Validator == RangeValidator< Value > {
        self.init(
            scope: scope,
            id: id,
            validator: .init(lower: lower),
            value: value
        )
    }
    
    @inlinable
    convenience init< Value : Comparable & Sendable >(
        scope: Scope,
        id: Id,
        value: Value,
        upper: Value
    ) where Validator == RangeValidator< Value > {
        self.init(
            scope: scope,
            id: id,
            validator: .init(upper: upper),
            value: value
        )
    }
    
    @inlinable
    convenience init< Value : Comparable & Sendable >(
        scope: Scope,
        id: Id,
        value: Value,
        lower: Value,
        upper: Value
    ) where Validator == RangeValidator< Value > {
        self.init(
            scope: scope,
            id: id,
            validator: .init(lower: lower, upper: upper),
            value: value
        )
    }
    
}
