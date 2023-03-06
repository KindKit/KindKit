//
//  KindKit
//

import Foundation

public protocol IOptionalConvertible {
    
    associatedtype Wrapped
    
    var asOptional: Optional< Wrapped > { get }
    
}

extension Optional : IOptionalConvertible {
    
    public var asOptional: Optional< Wrapped > {
        return self
    }
    
}
