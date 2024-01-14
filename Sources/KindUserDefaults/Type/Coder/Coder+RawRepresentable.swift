//
//  KindKit
//

import Foundation

public extension Coder {
    
    struct RawRepresentable< Enum : Swift.RawRepresentable, RawCoder > {
    }
    
}

extension Coder.RawRepresentable : IValueDecoder where RawCoder : IValueDecoder, Enum.RawValue == RawCoder.UserDefaultsDecoded {
    
    public static func decode(_ value: IValue) throws -> Enum {
        guard let rawValue = try? RawCoder.decode(value) else {
            throw Error.cast
        }
        guard let decoded = Enum(rawValue: rawValue) else {
            throw Error.cast
        }
        return decoded
    }

}

extension Coder.RawRepresentable : IValueEncoder where RawCoder : IValueEncoder, Enum.RawValue == RawCoder.UserDefaultsEncoded {
    
    public static func encode(_ value: Enum) throws -> IValue {
        return try RawCoder.encode(value.rawValue)
    }
    
}
