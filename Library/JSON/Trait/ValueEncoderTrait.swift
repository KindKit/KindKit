//
//  KindKit
//

import KindCodingOptions

public protocol ValueEncoderTrait {
    
    associatedtype JsonEncoded
    associatedtype JsonEncodeOptions : CodingOptions

    static func json(encode value: JsonEncoded, in path: Path, with options: JsonEncodeOptions) throws -> Field?
    
}

public extension ValueEncoderTrait where JsonEncodeOptions : DefaultCodingOptions {
    
    @inlinable
    static func json(encode value: JsonEncoded, in path: Path) throws -> Field? {
        return try self.json(encode: value, in: path, with: .default)
    }
    
}
