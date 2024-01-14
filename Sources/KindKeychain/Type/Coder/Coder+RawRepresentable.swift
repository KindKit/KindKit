//
//  KindKit
//

import Foundation

public extension Coder {
    
    struct RawRepresentable< Enum : Swift.RawRepresentable, RawCoder > {
    }
    
}

extension Coder.RawRepresentable : IValueDecoder where RawCoder : IValueDecoder, Enum.RawValue == RawCoder.KeychainDecoded {
    
    public static func decode(_ value: Data) throws -> Enum {
        guard let rawValue = try? RawCoder.decode(value) else {
            throw Error.cast
        }
        guard let decoded = Enum(rawValue: rawValue) else {
            throw Error.cast
        }
        return decoded
    }

}

extension Coder.RawRepresentable : IValueEncoder where RawCoder : IValueEncoder, Enum.RawValue == RawCoder.KeychainEncoded {
    
    public static func encode(_ value: Enum) throws -> Data {
        return try RawCoder.encode(value.rawValue)
    }
    
}
