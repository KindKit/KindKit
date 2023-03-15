//
//  KindKit
//

import Foundation

public protocol IOptionalConvertible {
    
    associatedtype Wrapped
    
    var asOptional: Wrapped? { get }
    
}

extension Optional : IOptionalConvertible {
    
    public var asOptional: Wrapped? {
        return self
    }
    
}
