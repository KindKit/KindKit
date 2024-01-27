//
//  KindKit
//

import Foundation
import KindCodingOptions

extension String : ValueDecoderTrait {
    
    public typealias JsonDecoded = String
    public typealias JsonDecodeOptions = StringDecodeOptions
    
    public static func json(decode field: Field, in path: Path, with options: JsonDecodeOptions) throws -> JsonDecoded {
        let value = try NSStringCoder.json(decode: field, in: path)
        if options.contains(.nonEmpty) == true {
            if value.length == 0 {
                throw CodingError(in: path)
            }
        }
        return value as String
    }
    
}

extension String : ValueEncoderTrait {
    
    public typealias JsonEncoded = String
    public typealias JsonEncodeOptions = EmptyCodingOptions
    
    public static func json(encode value: JsonEncoded, in path: Path, with options: JsonEncodeOptions) throws -> Field? {
        return try NSStringCoder.json(encode: value as NSString, in: path, with: options)
    }
    
}
