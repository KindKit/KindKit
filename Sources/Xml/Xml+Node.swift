//
//  KindKit
//

import Foundation

public extension Xml {
    
    final class Node {
        
        public var name: String
        public var attributes: [Xml.Attribute]
        public var nodes: [Node]
        public var value: Xml.Value?
        
        public init(name: String, attributes: [Xml.Attribute], nodes: [Node] = [], value: Xml.Value? = nil) {
            self.name = name
            self.attributes = attributes
            self.nodes = nodes
            self.value = value
        }
        
    }
    
}

public extension Xml.Node {
    
    func first(_ path: String) -> Xml.Node? {
        return self.nodes.first(where: { return $0.name == path })
    }
    
    func first< Paths : RandomAccessCollection >(_ path: Paths) -> Xml.Node? where Paths.Element == String {
        if path.isEmpty == false {
            if path.count == 1 {
                return self.first(path[path.startIndex])
            } else if let node = self.first(path[path.startIndex]) {
                return node.first(path.dropFirst())
            }
        }
        return nil
    }
    
}

#if DEBUG

extension Xml.Node : CustomDebugStringConvertible {

    public var debugDescription: String {
        return self.debugString()
    }
    
}

extension Xml.Node : IDebug {
    
    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1
        
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<XmlNode\n")
        
        DebugString("Name: \(self.name)\n", &buffer, indent, nextIndent, indent)
        if self.attributes.count > 0 {
            let debug = self.attributes.debugString(0, nextIndent, indent)
            DebugString("Attributes: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if self.nodes.count > 0 {
            let debug = self.nodes.debugString(0, nextIndent, indent)
            DebugString("Nodes: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        if let value = self.value {
            let debug = value.debugString(0, nextIndent, indent)
            DebugString("Value: \(debug)\n", &buffer, indent, nextIndent, indent)
        }
        
        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }
    
}

#endif
