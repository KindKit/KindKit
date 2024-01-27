//
//  KindKit
//

extension Optional : OptionalTrait {
    
    @inlinable
    public var asOptional: Wrapped? {
        return self
    }
    
}

extension Optional : MapTrait {
}
