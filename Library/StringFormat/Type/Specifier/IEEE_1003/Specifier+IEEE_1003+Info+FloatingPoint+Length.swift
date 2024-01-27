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
    
    func format< Value : BinaryInteger >(
        _ value: Value,
        length: Specifier.IEEE_1003.Info.FloatingPoint.Length
    ) -> String {
        switch length {
        case .default: return String(format: self, CDouble(value))
        case .long: return String(format: self, CLongDouble(value))
        }
    }
    
    func format< Value : BinaryFloatingPoint >(
        _ value: Value,
        length: Specifier.IEEE_1003.Info.FloatingPoint.Length
    ) -> String {
        switch length {
        case .default: return String(format: self, CDouble(value))
        case .long: return String(format: self, CLongDouble(value))
        }
    }

}
