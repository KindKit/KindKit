//
//  KindKit
//

import KindCore

public struct EmptyValidator< Value : Equatable > : Validator {
    
    public init() {
    }
    
    public func validate(value: Value) -> Never? {
        return nil
    }
    
    public func isEqual(_ other: Self) -> Bool {
        return true
    }
    
}

public extension InputField {
    
    @inlinable
    convenience init< Value : Equatable >(
        scope: Scope,
        id: Id,
        value: Value
    ) where Validator == EmptyValidator< Value > {
        self.init(
            scope: scope,
            id: id,
            validator: .init(),
            value: value
        )
    }
    
}
