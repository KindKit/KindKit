//
//  KindKit
//

public enum Language {
    
    case system
    
    case custom(String)
    
}

public extension Language {
    
    @inlinable
    static var en: Self { return .custom("en") }
    
    @inlinable
    static var ru: Self { return .custom("ru") }
    
}
