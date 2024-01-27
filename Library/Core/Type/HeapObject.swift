//
//  KindKit
//

public struct HeapObject< Content > {
    
    public typealias Content = Content
    
    public let content: Content
    
    public init(
        content: Content
    ) {
        self.content = content
    }
    
}

extension HeapObject : Equatable where Content : Equatable {
    
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.content == rhs.content
    }
    
}

extension HeapObject : MapTrait {
}
