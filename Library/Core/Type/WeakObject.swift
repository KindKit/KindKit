//
//  KindKit
//

public struct WeakObject< Content : AnyObject > {
    
    public typealias Content = Content

    public private(set) weak var content: Content?
    
    public var isValid: Bool {
        return self.content != nil
    }
    
    public init(
        content: Content? = nil
    ) {
        self.content = content
    }
    
}

extension WeakObject : Equatable where Content : Equatable {
    
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.content == rhs.content
    }
    
}

extension WeakObject : MapTrait {
}
