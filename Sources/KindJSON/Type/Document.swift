//
//  KindKit
//

import Foundation

public final class Document {

    public internal(set) var root: IValue?
    public let path: Path

    public init(
        path: Path = .root
    ) {
        self.path = path
    }

    public init(
        path: Path = .root,
        root: IValue
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
