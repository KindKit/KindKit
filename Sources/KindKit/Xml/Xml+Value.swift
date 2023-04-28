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
        return NSNumber.kk_number(from: self.text)
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
        return NSDecimalNumber.kk_decimalNumber(from: self.text)
    }
    
    var decimal: Decimal? {
        guard let decimalNumber = self.decimalNumber else { return nil }
        return decimalNumber as Decimal
    }
    
    var url: URL? {
        return URL(string: self.text)
    }
    
}

extension Xml.Value : CustomDebugStringConvertible {

    public var debugDescription: String {
        return self.dump()
    }
    
}

extension Xml.Value : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent, value: "Value")
            .append(inter: indent, value: self.text)
    }
    
}
