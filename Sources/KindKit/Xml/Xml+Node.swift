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

extension Xml.Node : CustomDebugStringConvertible {

    public var debugDescription: String {
        return self.dump()
    }
    
}

extension Xml.Node : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent, value: "Node")
        buff.append(inter: indent, key: "Name", value: self.name)
        if self.attributes.count > 0 {
            buff.append(inter: indent, key: "Attributes", value: self.attributes)
        }
        if self.nodes.count > 0 {
            buff.append(inter: indent, key: "Nodes", value: self.nodes)
        }
        if let value = self.value {
            buff.append(inter: indent, key: "Attributes", value: value)
        }
    }
    
}
