//
//  KindKit
//

import Foundation

public extension Json {

    struct Path : Hashable, Equatable {
        
        public let items: [Item]
        
        public init(
            items: [Item]
        ) {
            self.items = items
        }
        
        public init(
            string: String
        ) {
            let components = string.components(separatedBy: ".")
            let pattern = try! NSRegularExpression(pattern: "^\\[\\d+\\]$", options: .anchorsMatchLines)
            self.items = components.map({ (subpath: String) -> Json.Path.Item in
                guard let match = pattern.firstMatch(in: subpath, options: [], range: NSRange(location: 0, length: subpath.count)) else {
                    return .key(subpath)
                }
                guard (match.range.location != NSNotFound) && (match.range.length > 0) else {
                    return .key(subpath)
                }
                let startIndex = subpath.index(subpath.startIndex, offsetBy: 1)
                let endIndex = subpath.index(subpath.endIndex, offsetBy: -1)
                let indexString = String(subpath[startIndex ..< endIndex])
                guard let index = NSNumber.kk_number(from: indexString) else {
                    return .key(subpath)
                }
                return .index(index.intValue)
            })
        }
        
    }
    
}

extension Json.Path : ExpressibleByStringLiteral {
    
    @available(*, deprecated, renamed: "Json.Path.init(items:)")
    public init(stringLiteral value: Swift.StringLiteralType) {
        self.init(string: value)
    }
    
}

extension Json.Path : ExpressibleByArrayLiteral {
    
    public init(arrayLiteral: Item...) {
        self.items = .init(arrayLiteral)
    }
    
}

public extension Json.Path {
    
    @inlinable
    static var root: Self {
        return .init(items: [])
    }
    
    @inlinable
    static func from(
        string: String
    ) -> Self {
        return .init(string: string)
    }
    
}

public extension Json.Path {
    
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
    
}

public extension Json.Path {
    
    @inlinable
    func appending(_ path: Json.Path) -> Self {
        return .init(items: self.items + path.items)
    }
    
    @inlinable
    func appending(_ item: Json.Path.Item) -> Self {
        return .init(items: self.items + [ item ])
    }
    
    @inlinable
    func appending(_ path: Json.Path, to: Int) -> Self {
        return .init(items: self.items + path.items[path.items.startIndex ..< to])
    }
    
}

extension Json.Path : IDebug {
    
    public func debugInfo() -> Debug.Info {
        return .string(self.string)
    }

}

extension Json.Path : CustomStringConvertible {
}

extension Json.Path : CustomDebugStringConvertible {
}
