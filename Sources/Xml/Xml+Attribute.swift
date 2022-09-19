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


#if DEBUG

extension Xml.Attribute : CustomDebugStringConvertible {

    public var debugDescription: String {
        return self.debugString()
    }
    
}

extension Xml.Attribute : IDebug {
    
    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1
        
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<XmlAttribute\n")
        
        DebugString("Name: \(self.name)\n", &buffer, indent, nextIndent, indent)
        let valueDebug = self.value.debugString(0, nextIndent, indent)
        DebugString("Value: \(valueDebug)\n", &buffer, indent, nextIndent, indent)
        
        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }
    
}

#endif
