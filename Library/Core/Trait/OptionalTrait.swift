//
//  KindKit
//

public protocol OptionalTrait {
    
    associatedtype Wrapped
    
    var asOptional: Wrapped? { get }
    
}
