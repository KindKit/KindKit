//
//  KindKit
//

import KindDebug

public extension Document {
    
    struct Attribute {
        
        public var name: String
        public var value: Document.Value
        
        public init(name: String, value: Document.Value) {
            self.name = name
            self.value = value
        }
        
    }
    
}

extension Document.Attribute : KindDebug.IEntity {
    
    public func debugInfo() -> KindDebug.Info {
        return .sequence({ items in
            items.append(.pair(string: "Name", cast: self.name))
            items.append(.pair(string: "Value", cast: self.value))
        })
    }
    
}

extension Document.Attribute : CustomStringConvertible {
}

extension Document.Attribute : CustomDebugStringConvertible {
}

