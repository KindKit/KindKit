//
//  KindKit
//

import Foundation

public extension Xml {
    
    struct Value {
        
        public var text: String
        
        public init(text: String) {
            self.text = text
        }
        
    }
    
}

public extension Xml.Value {
    
    var number: NSNumber? {
        return NSNumber.number(from: self.text)
    }
    
    var int: Int? {
        guard let number = self.number else { return nil }
        return number.intValue
    }
    
    var uint: UInt? {
        guard let number = self.number else { return nil }
        return number.uintValue
    }
    
    var float: Float? {
        guard let number = self.number else { return nil }
        return number.floatValue
    }
    
    var double: Double? {
        guard let number = self.number else { return nil }
        return number.doubleValue
    }
    
    var decimalNumber: NSDecimalNumber? {
        return NSDecimalNumber.decimalNumber(from: self.text)
    }
    
    var decimal: Decimal? {
        guard let decimalNumber = self.decimalNumber else { return nil }
        return decimalNumber as Decimal
    }
    
    var url: URL? {
        return URL(string: self.text)
    }
    
}

#if DEBUG

extension Xml.Value : CustomDebugStringConvertible {

    public var debugDescription: String {
        return self.debugString()
    }
    
}

extension Xml.Value : IDebug {
    
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
