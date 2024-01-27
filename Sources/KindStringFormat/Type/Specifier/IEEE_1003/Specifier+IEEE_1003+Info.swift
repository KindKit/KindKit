//
//  KindKit
//

extension Specifier.IEEE_1003 {
    
    public enum Info : Equatable {
        
        case placeholder
        case char(Specifier.IEEE_1003.Info.Char)
        case string(Specifier.IEEE_1003.Info.String)
        case number(Specifier.IEEE_1003.Info.Number)
        case floatingPoint(Specifier.IEEE_1003.Info.FloatingPoint)
        case oct(Specifier.IEEE_1003.Info.Oct)
        case hex(Specifier.IEEE_1003.Info.Hex)
        case pointer(Specifier.IEEE_1003.Info.Pointer)
        case object(Specifier.IEEE_1003.Info.Object)
        
    }
    
}

extension Specifier.IEEE_1003.Info {
    
    init?(_ pattern: Pattern.IEEE_1003) {
        switch pattern.specifier {
        case "%": self = .placeholder
        case "d", "i": self = .numberSigned(pattern)
        case "u": self = .numberUnsigned(pattern)
        case "o": self = .oct(pattern)
        case "x": self = .hex(pattern)
        case "X": self = .hex(pattern, flags: .uppercase)
        case "f": self = .floatingPoint(pattern)
        case "F": self = .floatingPoint(pattern, flags: .uppercase)
        case "e": self = .floatingPoint(pattern, notation: .exponent)
        case "E": self = .floatingPoint(pattern, notation: .exponent, flags: .uppercase)
        case "g": self = .floatingPoint(pattern, notation: .auto)
        case "G": self = .floatingPoint(pattern, notation: .auto, flags: .uppercase)
        case "a": self = .floatingPoint(pattern, flags: .hex)
        case "A": self = .floatingPoint(pattern, flags: [ .hex, .uppercase ])
        case "c": self = .char(pattern, length: .utf8)
        case "C": self = .char(pattern, length: .utf16)
        case "s": self = .string(pattern, length: .utf8)
        case "S": self = .string(pattern, length: .utf16)
        case "p": self = .pointer(pattern)
        case "@": self = .object(pattern)
        default: return nil
        }
    }
    
    var string: Swift.String {
        var buffer = "%"
        self.append(&buffer)
        return buffer
    }
    
    @inlinable
    func append(_ buffer: inout Swift.String) {
        switch self {
        case .placeholder: buffer.append("%")
        case .char(let info): info.append(&buffer)
        case .string(let info): info.append(&buffer)
        case .number(let info): info.append(&buffer)
        case .floatingPoint(let info): info.append(&buffer)
        case .oct(let info): info.append(&buffer)
        case .hex(let info): info.append(&buffer)
        case .pointer(let info): info.append(&buffer)
        case .object(let info): info.append(&buffer)
        }
    }
    
    func format< ValueType : BinaryInteger >(_ value: ValueType) -> Swift.String? {
        switch self {
        case .placeholder: return nil
        case .char(let info): return value.kk_format(info)
        case .string(let info): return value.kk_format(info)
        case .number(let info):
            switch info {
            case .signed(let info): return value.kk_format(info)
            case .unsigned(let info): return value.kk_format(info)
            }
        case .floatingPoint(let info): return value.kk_format(info)
        case .oct(let info): return value.kk_format(info)
        case .hex(let info): return value.kk_format(info)
        case .pointer(let info): return value.kk_format(info)
        case .object(let info): return value.kk_format(info)
        }
    }
    
    func format< ValueType : BinaryFloatingPoint >(_ value: ValueType) -> Swift.String? {
        switch self {
        case .placeholder: return nil
        case .char(let info): return value.kk_format(info)
        case .string(let info): return value.kk_format(info)
        case .number(let info):
            switch info {
            case .signed(let info): return value.kk_format(info)
            case .unsigned(let info): return value.kk_format(info)
            }
        case .floatingPoint(let info): return value.kk_format(info)
        case .oct(let info): return value.kk_format(info)
        case .hex(let info): return value.kk_format(info)
        case .pointer(let info): return value.kk_format(info)
        case .object(let info): return value.kk_format(info)
        }
    }
    
    func format(_ value: Swift.String) -> Swift.String? {
        switch self {
        case .placeholder: return nil
        case .char(let info): return value.kk_format(info)
        case .string(let info): return value.kk_format(info)
        case .number(let info):
            switch info {
            case .signed(let info): return value.kk_format(info)
            case .unsigned(let info): return value.kk_format(info)
            }
        case .floatingPoint(let info): return value.kk_format(info)
        case .oct(let info): return value.kk_format(info)
        case .hex(let info): return value.kk_format(info)
        case .pointer(let info): return value.kk_format(info)
        case .object(let info): return value.kk_format(info)
        }
    }

}
