//
//  KindKit
//

public protocol LazyTrait {
    
    associatedtype Owner : AnyObject & Sendable
    associatedtype Content : Sendable
    
    static func create(owner: Owner) -> Content
    static func cleanup(owner: Owner, content: Content)
    
}
