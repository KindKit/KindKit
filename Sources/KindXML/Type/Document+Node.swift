//
//  KindKit
//

import KindDebug

public extension Document {
    
    final class Node {
        
        public var name: String
        public var attributes: [Document.Attribute]
        public var nodes: [Node]
        public var value: Document.Value?
        
        public init(name: String, attributes: [Document.Attribute], nodes: [Node] = [], value: Document.Value? = nil) {
            self.name = name
            self.attributes = attributes
            self.nodes = nodes
            self.value = value
        }
        
    }
    
}

public extension Document.Node {
    
    func first(_ path: String) -> Document.Node? {
        return self.nodes.first(where: { return $0.name == path })
    }
    
    func first< Paths : RandomAccessCollection >(_ path: Paths) -> Document.Node? where Paths.Element == String {
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

extension Document.Node : KindDebug.IEntity {
    
    public func debugInfo() -> KindDebug.Info {
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

extension Document.Node : CustomStringConvertible {
}

extension Document.Node : CustomDebugStringConvertible {
}
