//
//  KindKit
//

import Foundation
import KindCodingOptions

extension Date : ValueDecoderTrait {
    
    public typealias JsonDecoded = Date
    public typealias JsonDecodeOptions = DateDecodeOptions
    
    public static func json(decode field: Field, in path: Path, with options: JsonDecodeOptions) throws -> JsonDecoded {
        for format in options.formats {
            switch format {
            case .numberRepresentable(let representable):
                switch representable {
                case .unixtime:
                    guard let timestamp = try? UInt.json(decode: field, in: path) else {
                        continue
                    }
                    return Date(timeIntervalSince1970: .init(timestamp))
                }
            case .stringRepresentable(let representable):
                guard let string = try? String.json(decode: field, in: path, with: .nonEmpty) else {
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
        throw CodingError(in: path)
    }
    
}

extension Date : ValueEncoderTrait {
    
    public typealias JsonEncoded = Date
    public typealias JsonEncodeOptions = DateEncodeOptions
    
    public static func json(encode value: JsonEncoded, in path: Path, with options: JsonEncodeOptions) throws -> Field? {
        switch options.format {
        case .numberRepresentable(let representable):
            switch representable {
            case .unixtime:
                return try UInt.json(encode: .init(value.timeIntervalSince1970), in: path)
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
            return try String.json(encode: formatter.string(from: value), in: path)
        }
    }
    
}
