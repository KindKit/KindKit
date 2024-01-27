//
//  KindKit
//

public struct Path {
    
    public let items: [Item]
    
    public init(
        _ items: [Item]
    ) {
        self.items = items
    }
    
}

extension Path : ExpressibleByArrayLiteral {
    
    public init(arrayLiteral: Item...) {
        self.items = .init(arrayLiteral)
    }
    
}

extension Path : ExpressibleByStringLiteral {
    
    public init(stringLiteral value: Swift.StringLiteralType) {
        self.items = [ .key(value) ]
    }
    
}

extension Path : ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: Swift.IntegerLiteralType) {
        self.items = [ .index(value) ]
    }
    
}

extension Path : Hashable {
}

extension Path : Equatable {
}

extension Path : Sendable {
}

public extension Path {
    
    @inlinable
    static var root: Self {
        return .init([])
    }
    
    @inlinable
    var isRoot: Bool {
        return self.items.isEmpty == true
    }
    
    @inlinable
    var string: String {
        let items = self.items.map({
            switch $0 {
            case .key(let key): return "\(key)"
            case .index(let index): return "[\(index)]"
            }
        })
        return items.joined(separator: ".")
    }
    
    @inlinable
    func appending(_ path: Path) -> Self {
        return .init(self.items + path.items)
    }
    
    @inlinable
    func appending(_ item: Path.Item) -> Self {
        return .init(self.items + [ item ])
    }
    
    @inlinable
    func appending(_ path: Path, to: Int) -> Self {
        return .init(self.items + path.items[path.items.startIndex ..< to])
    }
    
}
