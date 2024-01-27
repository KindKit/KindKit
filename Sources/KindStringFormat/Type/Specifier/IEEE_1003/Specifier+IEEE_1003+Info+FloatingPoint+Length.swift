//
//  KindKit
//

extension Specifier.IEEE_1003.Info.FloatingPoint {
    
    public enum Length {
        
        case `default`
        case long
        
    }
    
}

extension Specifier.IEEE_1003.Info.FloatingPoint.Length {
    
    init(_ pattern: Pattern.IEEE_1003) {
        switch pattern.length {
        case "l": self = .long
        default: self = .default
        }
    }
    
    @inlinable
    func append(_ buffer: inout Swift.String) {
        switch self {
        case .default: break
        case .long: buffer.append("L")
        }
    }

}

extension String {
    
    func format< ValueType : BinaryInteger >(
        _ value: ValueType,
        length: Specifier.IEEE_1003.Info.FloatingPoint.Length
    ) -> String {
        switch length {
        case .default: return String(format: self, CDouble(value))
        case .long: return String(format: self, CLongDouble(value))
        }
    }
    
    func format< ValueType : BinaryFloatingPoint >(
        _ value: ValueType,
        length: Specifier.IEEE_1003.Info.FloatingPoint.Length
    ) -> String {
        switch length {
        case .default: return String(format: self, CDouble(value))
        case .long: return String(format: self, CLongDouble(value))
        }
    }

}
