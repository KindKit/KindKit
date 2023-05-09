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

extension Xml.Node : IDebug {
    
    public func debugInfo() -> Debug.Info {
        return .object(name: "Node", sequence: { items in
            items.append(.pair(string: "Name", cast: self.name))
            if self.attributes.count > 0 {
                items.append(.pair(string: "Attributes", cast: self.attributes))
            }
            if self.nodes.count > 0 {
                items.append(.pair(string: "Nodes", cast: self.nodes))
            }
            if let value = self.value {
                items.append(.pair(string: "Value", cast: value))
            }
        })
    }
    
}

extension Xml.Node : CustomStringConvertible {
}

extension Xml.Node : CustomDebugStringConvertible {
}
