//
//  KindKit
//

import Foundation

public final class Json {

    public internal(set) var root: IJsonValue?
    public let path: Json.Path

    public init(
        path: Json.Path = .root
    ) {
        self.path = path
    }

    public init(
        path: Json.Path = .root,
        root: IJsonValue
    ) {
        self.root = root
        self.path = path
    }
    
}

public extension Json {
    
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
