//
//  KindKit
//

import Foundation
import KindCodingOptions

extension URL : ValueDecoderTrait {
    
    public typealias JsonDecoded = Self
    public typealias JsonDecodeOptions = URLDecodeOptions
    
    public static func json(decode field: Field, in path: Path, with options: JsonDecodeOptions) throws -> JsonDecoded {
        let string = try String.json(decode: field, in: path, with: .nonEmpty)
        guard let url = URL(string: string, relativeTo: options.base) else {
            throw CodingError(in: path)
        }
        guard options.require.validate(url: url) == true else {
            throw CodingError(in: path)
        }
        return url.absoluteURL
    }
    
}

extension URL : ValueEncoderTrait {
    
    public typealias JsonEncoded = Self
    public typealias JsonEncodeOptions = URLEncodeOptions
    
    public static func json(encode value: JsonEncoded, in path: Path, with options: JsonEncodeOptions) throws -> Field? {
        guard let url = options.removing.removing(url: value) else {
            throw CodingError(in: path)
        }
        return try String.json(encode: url.absoluteString, in: path)
    }
    
}
