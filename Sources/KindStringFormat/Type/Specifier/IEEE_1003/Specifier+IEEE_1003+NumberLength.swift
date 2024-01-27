//
//  KindKit
//

extension Specifier.IEEE_1003 {
    
    public enum NumberLength {
        
        case `default`
        case char
        case short
        case long
        case longLong
        
    }
    
}

extension Specifier.IEEE_1003.NumberLength {
    
    init(_ pattern: Pattern.IEEE_1003) {
        switch pattern.length {
        case "hh": self = .char
        case "h": self = .short
        case "l": self = .long
        case "ll": self = .longLong
        default: self = .default
        }
    }
    
    @inlinable
    func append(_ buffer: inout Swift.String) {
        switch self {
        case .default: break
        case .char: buffer.append("hh")
        case .short: buffer.append("h")
        case .long: buffer.append("l")
        case .longLong: buffer.append("ll")
        }
    }
    
}

extension String {
    
    func format< ValueType : BinaryInteger >(
        _ value: ValueType,
        length: Specifier.IEEE_1003.NumberLength
    ) -> String {
        switch length {
        case .default: return String(format: self, CInt(value))
        case .char: return String(format: self, CChar(value))
        case .short: return String(format: self, CShort(value))
        case .long: return String(format: self, CLong(value))
        case .longLong: return String(format: self, CLongLong(value))
        }
    }
    
    func format< ValueType : BinaryFloatingPoint >(
        _ value: ValueType,
        length: Specifier.IEEE_1003.NumberLength
    ) -> String {
        switch length {
        case .default: return String(format: self, CInt(value))
        case .char: return String(format: self, CChar(value))
        case .short: return String(format: self, CShort(value))
        case .long: return String(format: self, CLong(value))
        case .longLong: return String(format: self, CLongLong(value))
        }
    }

}
