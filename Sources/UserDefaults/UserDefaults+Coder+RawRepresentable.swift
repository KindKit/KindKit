//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {
    
    struct RawRepresentable< Enum : Swift.RawRepresentable, RawCoder > {
    }
    
}

extension UserDefaults.Coder.RawRepresentable : IUserDefaultsValueDecoder where RawCoder : IUserDefaultsValueDecoder, Enum.RawValue == RawCoder.UserDefaultsDecoded {
    
    public static func decode(_ value: IUserDefaultsValue) throws -> Enum {
        guard let rawValue = try? RawCoder.decode(value) else {
            throw UserDefaults.Error.cast
        }
        guard let decoded = Enum(rawValue: rawValue) else {
            throw UserDefaults.Error.cast
        }
        return decoded
    }

}

extension UserDefaults.Coder.RawRepresentable : IUserDefaultsValueEncoder where RawCoder : IUserDefaultsValueEncoder, Enum.RawValue == RawCoder.UserDefaultsEncoded {
    
    public static func encode(_ value: Enum) throws -> IUserDefaultsValue {
        return try RawCoder.encode(value.rawValue)
    }
    
}
