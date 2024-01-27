//
//  KindKit
//

public protocol ReuseTrait : LazyTrait {
    
    static func name(owner: Owner) -> String
    static func configure(owner: Owner, content: Content)
    
}
