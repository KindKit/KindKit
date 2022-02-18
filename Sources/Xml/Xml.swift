//
//  KindKitXml
//

import Foundation
import KindKitCore

public final class XmlDocument {
    
    public var nodes: [XmlNode]
    
    public init(nodes: [XmlNode] = []) {
        self.nodes = nodes
    }
    
    public func first(_ path: String) -> XmlNode? {
        return self.nodes.first(where: { return $0.name == path })
    }
    
    public func first(_ path: Array< String >) -> XmlNode? {
        if path.isEmpty == false {
            if path.count == 1 {
                return self.first(path[path.startIndex])
            } else if let node = self.first(path[path.startIndex]) {
                let subpath = Array< String >(path.dropFirst())
                return node.first(subpath)
            }
        }
        return nil
    }
    
}

public final class XmlNode {
    
    public var name: String
    public var attributes: [XmlAttribute]
    public var nodes: [XmlNode]
    public var value: XmlValue?
    
    public init(name: String, attributes: [XmlAttribute], nodes: [XmlNode] = [], value: XmlValue? = nil) {
        self.name = name
        self.attributes = attributes
        self.nodes = nodes
        self.value = value
    }
    
    public func first(_ path: String) -> XmlNode? {
        return self.nodes.first(where: { return $0.name == path })
    }
    
    public func first(_ path: Array< String >) -> XmlNode? {
        if path.isEmpty == false {
            if path.count == 1 {
                return self.first(path[path.startIndex])
            } else if let node = self.first(path[path.startIndex]) {
                return node.first(path.dropFirst())
            }
        }
        return nil
    }
    
    public func first(_ path: ArraySlice< String >) -> XmlNode? {
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

public struct XmlAttribute {
    
    public var name: String
    public var value: XmlValue
    
    public init(name: String, value: XmlValue) {
        self.name = name
        self.value = value
    }
    
}

public struct XmlValue {
    
    public var text: String
    
    public init(text: String) {
        self.text = text
    }
    
    public func asNumber() -> NSNumber? {
        return NSNumber.number(from: self.text)
    }
    
    public func asInt() -> Int? {
        guard let number = self.asNumber() else { return nil }
        return number.intValue
    }
    
    public func asUInt() -> UInt? {
        guard let number = self.asNumber() else { return nil }
        return number.uintValue
    }
    
    public func asFloat() -> Float? {
        guard let number = self.asNumber() else { return nil }
        return number.floatValue
    }
    
    public func asDouble() -> Double? {
        guard let number = self.asNumber() else { return nil }
        return number.doubleValue
    }
    
    public func asDecimalNumber() -> NSDecimalNumber? {
        return NSDecimalNumber.decimalNumber(from: self.text)
    }
    
    public func asDecimal() -> Decimal? {
        guard let decimalNumber = self.asDecimalNumber() else { return nil }
        return decimalNumber as Decimal
    }
    
    public func asUrl() -> URL? {
        return URL(string: self.text)
    }
    
}

#if DEBUG

extension XmlDocument : IDebug {
    
    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1
        
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<XmlDocument\n")
        
        if self.nodes.count > 0 {
            self.nodes.debugString(&buffer, indent, nextIndent, indent)
        }
        
        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }
    
}

extension XmlNode : IDebug {
    
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

extension XmlAttribute : IDebug {
    
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

extension XmlValue : IDebug {
    
    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        let nextIndent = indent + 1
        
        if headerIndent > 0 {
            buffer.append(String(repeating: "\t", count: headerIndent))
        }
        buffer.append("<XmlValue\n")
        
        DebugString("\(self.text)\n", &buffer, indent, nextIndent, indent)
        
        if footerIndent > 0 {
            buffer.append(String(repeating: "\t", count: footerIndent))
        }
        buffer.append(">")
    }
    
}

#endif
