//
//  KindKit
//

import Foundation

public extension Xml {
    
    struct Attribute {
        
        public var name: String
        public var value: Xml.Value
        
        public init(name: String, value: Xml.Value) {
            self.name = name
            self.value = value
        }
        
    }
    
}

extension Xml.Attribute : IDebug {
    
    public func debugInfo() -> Debug.Info {
        return .sequence({ items in
            items.append(.pair(string: "Name", cast: self.name))
            items.append(.pair(string: "Value", cast: self.value))
        })
    }
    
}

extension Xml.Attribute : CustomStringConvertible {
}

extension Xml.Attribute : CustomDebugStringConvertible {
}

