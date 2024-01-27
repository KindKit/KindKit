//
//  KindKit
//

import Foundation

public extension BinaryInteger {
    
    func kk_format(_ specifier: Specifier.IEEE_1003.Info.Char) -> String? {
        let string: Swift.String
        switch specifier.length {
        case .utf8:
            let unicode = UnicodeScalar(UInt8(self))
            string = .init(unicode)
        case .utf16:
            guard let unicode = UnicodeScalar(UInt16(self)) else { return nil }
            string = .init(unicode)
        }
        switch specifier.length {
        case .utf8:
            return string.withCString({
                return String(format: specifier.string, $0)
            })
        case .utf16:
            guard let data = string.data(using: .utf16) else { return nil }
            return data.withUnsafeBytes({
                guard let baseAddress = $0.baseAddress else { return nil }
                return String(format: specifier.string, OpaquePointer(baseAddress))
            })
        }
    }
    
    func kk_format(_ specifier: Specifier.IEEE_1003.Info.FloatingPoint) -> String? {
        switch specifier.length {
        case .default: return CDouble(self).kk_format(specifier)
        case .long: return CLongDouble(self).kk_format(specifier)
        }
    }
    
    func kk_format(_ specifier: Specifier.IEEE_1003.Info.Hex) -> String? {
        let format = specifier.string
        switch specifier.length {
        case .default: return String(format: format, CUnsignedInt(self))
        case .char: return String(format: format, CUnsignedChar(self))
        case .short: return String(format: format, CUnsignedShort(self))
        case .long: return String(format: format, CUnsignedLong(self))
        case .longLong: return String(format: format, CUnsignedLongLong(self))
        }
    }
    
    func kk_format(_ specifier: Specifier.IEEE_1003.Info.Number.Signed) -> String? {
        let format = specifier.string
        switch specifier.length {
        case .default: return String(format: format, CInt(self))
        case .char: return String(format: format, CChar(self))
        case .short: return String(format: format, CShort(self))
        case .long: return String(format: format, CLong(self))
        case .longLong: return String(format: format, CLongLong(self))
        }
    }
    
    func kk_format(_ specifier: Specifier.IEEE_1003.Info.Number.Unsigned) -> String? {
        let format = specifier.string
        switch specifier.length {
        case .default: return String(format: format, CUnsignedInt(self))
        case .char: return String(format: format, CUnsignedChar(self))
        case .short: return String(format: format, CUnsignedShort(self))
        case .long: return String(format: format, CUnsignedLong(self))
        case .longLong: return String(format: format, CUnsignedLongLong(self))
        }
    }
    
    func kk_format(_ specifier: Specifier.IEEE_1003.Info.Object) -> String? {
        return String(self).kk_format(specifier)
    }
    
    func kk_format(_ specifier: Specifier.IEEE_1003.Info.Oct) -> String? {
        let format = specifier.string
        switch specifier.length {
        case .default: return String(format: format, CInt(self))
        case .char: return String(format: format, CChar(self))
        case .short: return String(format: format, CShort(self))
        case .long: return String(format: format, CLong(self))
        case .longLong: return String(format: format, CLongLong(self))
        }
    }
    
    func kk_format(_ specifier: Specifier.IEEE_1003.Info.Pointer) -> String? {
        return self.kk_format(Specifier.IEEE_1003.Info.Number.Unsigned(
            alignment: specifier.alignment,
            width: .default,
            length: .default,
            flags: []
        ))
    }
    
    func kk_format(_ specifier: Specifier.IEEE_1003.Info.String) -> String? {
        return String(self).kk_format(specifier)
    }
    
}
