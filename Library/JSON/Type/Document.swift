//
//  KindKit
//

import Foundation

public final class Document {

    public internal(set) var root: Field?
    public let path: Path

    public init(
        in path: Path = .root
    ) {
        self.path = path
    }

    public init(
        in path: Path = .root,
        root: Field
    ) {
        self.root = root
        self.path = path
    }
    
}

public extension Document {
    
    var isEmpty: Bool {
        return self.root == nil
    }
    
    var isDictionary: Bool {
        return self.root is NSDictionary
    }
    
    var dictionary: NSDictionary? {
        return self.root as? NSDictionary
    }
    
    var isArray: Bool {
        return self.root is NSArray
    }
    
    var array: NSArray? {
        return self.root as? NSArray
    }
    
}

extension Document : Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}

extension Document : Equatable {
    
    public static func == (lhs: Document, rhs: Document) -> Bool {
        guard lhs.path == rhs.path else { return false }
        switch (lhs.root, rhs.root) {
        case (.some(let lhs), .some(let rhs)): return lhs.isEqual(rhs)
        default: return false
        }
    }
    
}

extension Document : @unchecked Sendable {
}
