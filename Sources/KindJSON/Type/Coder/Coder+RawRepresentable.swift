//
//  KindKit
//

import Foundation

public extension Coder {
    
    struct RawRepresentable< Enum : Swift.RawRepresentable, RawCoder > {
    }
    
}

extension Coder.RawRepresentable : IValueDecoder where RawCoder : IValueDecoder, Enum.RawValue == RawCoder.JsonDecoded {
    
    public typealias JsonDecoded = Enum
    
    public static func decode(_ value: IValue, path: Path) throws -> JsonDecoded {
        let value = try RawCoder.decode(value, path: path)
        guard let value = Enum(rawValue: value) else {
            throw Error.Coding.cast(path)
        }
        return value
    }

}

extension Coder.RawRepresentable : IValueEncoder where RawCoder : IValueEncoder, Enum.RawValue == RawCoder.JsonEncoded {
    
    public typealias JsonEncoded = Enum
    
    public static func encode(_ value: JsonEncoded, path: Path) throws -> IValue {
        return try RawCoder.encode(value.rawValue, path: path)
    }
    
}
