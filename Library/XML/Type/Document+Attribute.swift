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

extension Document.Attribute : DebugTrait {
    
    public func buildInfo() -> Info {
        return SequenceInfo({
            KeyValueInfo(key: "Name", value: self.name)
            KeyValueInfo(key: "Value", value: self.value)
        })
    }
    
}

extension Document.Attribute : CustomStringConvertible {
}

extension Document.Attribute : CustomDebugStringConvertible {
}

