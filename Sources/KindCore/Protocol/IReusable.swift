//
//  KindKit
//

public protocol IReusable {
    
    associatedtype Owner : AnyObject
    associatedtype Content
    
    static var reuseIdentificator: String { get }
    
    static func createReuse(owner: Owner) -> Content
    static func configureReuse(owner: Owner, content: Content)
    static func cleanupReuse(content: Content)
    
}
