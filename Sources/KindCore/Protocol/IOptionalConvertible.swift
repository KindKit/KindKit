//
//  KindKit
//

public protocol IOptionalConvertible {
    
    associatedtype Wrapped
    
    var asOptional: Wrapped? { get }
    
}

extension Optional : IOptionalConvertible {
    
    @inlinable
    public var asOptional: Wrapped? {
        return self
    }
    
}
