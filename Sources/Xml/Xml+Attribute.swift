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

extension Xml.Attribute : CustomDebugStringConvertible {

    public var debugDescription: String {
        return self.dump()
    }
    
}

extension Xml.Attribute : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent, data: "<Xml.Attribute")
            .append(inter: indent, key: "Name", value: self.name)
            .append(inter: indent, key: "Value", value: self.value)
            .append(footer: indent, data: ">")
    }
    
}
