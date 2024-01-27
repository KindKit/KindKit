//
//  KindKit
//

import Foundation
import KindCore

public extension String {
    
    func kk_format(_ specifier: Specifier.IEEE_1003.Info.Char) -> String? {
        guard self.isEmpty == false else {
            return nil
        }
        let string = String(self[self.startIndex])
        return string.kk_format(Specifier.IEEE_1003.Info.String(
            alignment: specifier.alignment,
            width: specifier.width,
            length: specifier.length
        ))
    }
    
    func kk_format(_ specifier: Specifier.IEEE_1003.Info.FloatingPoint) -> String? {
        guard let number = NSNumber.kk_number(from: self) else {
            return self.kk_format(Specifier.IEEE_1003.Info.String(
                alignment: specifier.alignment,
                width: specifier.width,
                length: .utf8
            ))
        }
        return number.doubleValue.kk_format(specifier)
    }
    
    func kk_format(_ specifier: Specifier.IEEE_1003.Info.Hex) -> String? {
        guard let number = NSNumber.kk_number(from: self) else {
            return self.kk_format(Specifier.IEEE_1003.Info.String(
                alignment: specifier.alignment,
                width: specifier.width,
                length: .utf8
            ))
        }
        return number.uint64Value.kk_format(specifier)
    }
    
    func kk_format(_ specifier: Specifier.IEEE_1003.Info.Number.Signed) -> String? {
        guard let number = NSNumber.kk_number(from: self) else {
            return self.kk_format(Specifier.IEEE_1003.Info.String(
                alignment: specifier.alignment,
                width: specifier.width,
                length: .utf8
            ))
        }
        return number.int64Value.kk_format(specifier)
    }
    
    func kk_format(_ specifier: Specifier.IEEE_1003.Info.Number.Unsigned) -> String? {
        guard let number = NSNumber.kk_number(from: self) else {
            return self.kk_format(Specifier.IEEE_1003.Info.String(
                alignment: specifier.alignment,
                width: specifier.width,
                length: .utf8
            ))
        }
        return number.uint64Value.kk_format(specifier)
    }
    
    func kk_format(_ specifier: Specifier.IEEE_1003.Info.Object) -> String? {
        return self.kk_format(Specifier.IEEE_1003.Info.String(
            alignment: specifier.alignment,
            width: specifier.width,
            length: .utf8
        ))
    }
    
    func kk_format(_ specifier: Specifier.IEEE_1003.Info.Oct) -> String? {
        guard let number = NSNumber.kk_number(from: self) else {
            return self.kk_format(Specifier.IEEE_1003.Info.String(
                alignment: specifier.alignment,
                width: specifier.width,
                length: .utf8
            ))
        }
        return number.int64Value.kk_format(specifier)
    }
    
    func kk_format(_ specifier: Specifier.IEEE_1003.Info.Pointer) -> String? {
        return self.kk_format(Specifier.IEEE_1003.Info.String(
            alignment: specifier.alignment,
            width: .default,
            length: .utf8
        ))
    }
    
    func kk_format(_ specifier: Specifier.IEEE_1003.Info.String) -> String? {
        switch specifier.length {
        case .utf8:
            let format = specifier.string
            return self.withCString({
                return String(format: format, $0)
            })
        case .utf16:
            let specifier = Specifier.IEEE_1003.Info.Object(
                alignment: specifier.alignment,
                width: specifier.width
            )
            let format = specifier.string
            return String(format: format, self)
        }
    }
    
}
