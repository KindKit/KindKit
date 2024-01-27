//
//  KindKit
//

public struct Path : Hashable, Equatable {
    
    public let ids: [Id]
    
    public init() {
        self.ids = []
    }
    
    public init(
        root id: Id
    ) {
        self.ids = [ id ]
    }
    
    public init< Ids : RandomAccessCollection >(
        ids: Ids
    ) where Ids.Element == Id {
        self.ids = .init(ids)
    }
    
}

public extension Path {
    
    @inlinable
    var isEmpty: Bool {
        return self.ids.isEmpty
    }
    
    @inlinable
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    @inlinable
    subscript (_ index: Int) -> Id {
        return self.ids[index]
    }
    
    @inlinable
    subscript (_ range: Range< Int >) -> Self {
        return .init(ids: self.ids[range])
    }
    
}
