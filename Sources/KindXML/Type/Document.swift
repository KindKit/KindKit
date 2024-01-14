//
//  KindKit
//

import KindDebug

public final class Document {
    
    public var nodes: [Node]
    
    public init(nodes: [Node] = []) {
        self.nodes = nodes
    }
    
    public init(data: Data) throws {
        let delegate = Parser()
        let parser = XMLParser(data: data)
        parser.delegate = delegate
        if parser.parse() == true {
            self.nodes = delegate.nodes
        } else {
            throw parser.parserError!
        }
    }
    
}

public extension Document {
    
    func first(_ path: String) -> Node? {
        return self.nodes.first(where: { return $0.name == path })
    }
    
    func first< Paths : RandomAccessCollection >(_ path: Paths) -> Node? where Paths.Element == String {
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

extension Document : KindDebug.IEntity {
    
    public func debugInfo() -> KindDebug.Info {
        return .sequence(self.nodes.map({ $0.debugInfo() }))
    }
    
}

extension Document : CustomStringConvertible {
}

extension Document : CustomDebugStringConvertible {
}

