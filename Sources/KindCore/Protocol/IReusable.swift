//
//  KindKit
//

public protocol IReusable : ILazyable {
    
    static func name(owner: Owner) -> String
    static func configure(owner: Owner, content: Content)
    
}
