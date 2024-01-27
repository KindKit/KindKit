//
//  KindKit
//

import Foundation
import KindCodingOptions

extension Date : ValueDecoderTrait {
    
    public typealias UserDefaultsDecoded = Date
    public typealias UserDefaultsDecodeOptions = DateDecodeOptions
    
    public static func userDefaults(decode field: Field, by key: String, with options: UserDefaultsDecodeOptions) throws -> UserDefaultsDecoded {
        for format in options.formats {
            switch format {
            case .numberRepresentable(let representable):
                switch representable {
                case .unixtime:
                    guard let timestamp = try? UInt.userDefaults(decode: field, by: key) else {
                        continue
                    }
                    return Date(timeIntervalSince1970: .init(timestamp))
                }
            case .stringRepresentable(let representable):
                guard let string = try? String.userDefaults(decode: field, by: key, with: .nonEmpty) else {
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
        throw CodingError(by: key)
    }
    
}

extension Date : ValueEncoderTrait {
    
    public typealias UserDefaultsEncoded = Date
    public typealias UserDefaultsEncodeOptions = DateEncodeOptions
    
    public static func userDefaults(encode value: UserDefaultsEncoded, by key: String, with options: UserDefaultsEncodeOptions) throws -> Field? {
        switch options.format {
        case .numberRepresentable(let representable):
            switch representable {
            case .unixtime:
                return try UInt.userDefaults(encode: .init(value.timeIntervalSince1970), by: key)
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
            return try String.userDefaults(encode: formatter.string(from: value), by: key)
        }
    }
    
}
