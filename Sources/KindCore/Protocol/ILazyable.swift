//
//  KindKit
//

public protocol ILazyable {
    
    associatedtype Owner : AnyObject
    associatedtype Content
    
    static func create(owner: Owner) -> Content
    static func cleanup(owner: Owner, content: Content)
    
}
