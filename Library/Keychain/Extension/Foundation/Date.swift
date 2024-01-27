//
//  KindKit
//

import Foundation
import KindCodingOptions

extension Date : ValueDecoderTrait {
    
    public typealias KeychainDecoded = Date
    public typealias KeychainDecodeOptions = DateDecodeOptions
    
    public static func keychain(decode field: Data, in key: String, with options: KeychainDecodeOptions) throws -> KeychainDecoded {
        for format in options.formats {
            switch format {
            case .numberRepresentable(let representable):
                switch representable {
                case .unixtime:
                    guard let timestamp = try? UInt.keychain(decode: field, in: key) else {
                        continue
                    }
                    return Date(timeIntervalSince1970: .init(timestamp))
                }
            case .stringRepresentable(let representable):
                guard let string = try? String.keychain(decode: field, in: key, with: .nonEmpty) else {
                    continue
                }
                let formatter = Foundation.DateFormatter()
                if let locale = representable.locale {
                    formatter.locale = locale
                }
                if let timeZone = representable.timeZone {
                    formatter.timeZone = timeZone
                }
                formatter.dateFormat = representable.format
                guard let date = formatter.date(from: string) else {
                    continue
                }
                return date
            }
        }
        throw CodingError(in: key)
    }
    
}

extension Date : ValueEncoderTrait {
    
    public typealias KeychainEncoded = Date
    public typealias KeychainEncodeOptions = DateEncodeOptions
    
    public static func keychain(encode value: KeychainEncoded, in key: String, with options: KeychainEncodeOptions) throws -> Data? {
        switch options.format {
        case .numberRepresentable(let representable):
            switch representable {
            case .unixtime:
                return try UInt.keychain(encode: .init(value.timeIntervalSince1970), in: key)
            }
        case .stringRepresentable(let representable):
            let formatter = Foundation.DateFormatter()
            if let locale = representable.locale {
                formatter.locale = locale
            }
            if let timeZone = representable.timeZone {
                formatter.timeZone = timeZone
            }
            formatter.dateFormat = representable.format
            return try String.keychain(encode: formatter.string(from: value), in: key)
        }
    }
    
}
