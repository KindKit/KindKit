//
//  KindKit
//

import Foundation

public extension BinaryFloatingPoint {
    
    func kk_format(_ specifier: Specifier.IEEE_1003.Info.Char) -> String? {
        return self.kk_format(Specifier.IEEE_1003.Info.String(
            alignment: specifier.alignment,
            width: specifier.width,
            length: specifier.length
        ))
    }
    
    func kk_format(_ specifier: Specifier.IEEE_1003.Info.FloatingPoint) -> String? {
        let format = specifier.string
        switch specifier.length {
        case .default: return String(format: format, CDouble(self))
        case .long: return String(format: format, CLongDouble(self))
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
        return self.kk_format(Specifier.IEEE_1003.Info.String(
            alignment: specifier.alignment,
            width: specifier.width,
            length: .utf8
        ))
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
        return self.kk_format(Specifier.IEEE_1003.Info.FloatingPoint(
            alignment: specifier.alignment,
            width: .default,
            precision: .default,
            length: .default,
            notation: .normal,
            flags: []
        ))
    }
    
    func kk_format(_ specifier: Specifier.IEEE_1003.Info.String) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        guard let string = formatter.string(for: self) else {
            return nil
        }
        return string.kk_format(specifier)
    }
    
}
