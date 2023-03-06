//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {
    
    struct Identifier< Coder, Kind : IIdentifierKind > {
    }
    
}

extension UserDefaults.Coder.Identifier : IUserDefaultsValueDecoder where Coder : IUserDefaultsValueDecoder {
    
    public static func decode(_ value: IUserDefaultsValue) throws -> KindKit.Identifier< Coder.UserDefaultsDecoded, Kind > {
        return Identifier(try Coder.decode(value))
    }
    
}

extension UserDefaults.Coder.Identifier : IUserDefaultsValueEncoder where Coder : IUserDefaultsValueEncoder {
    
    public static func encode(_ value: KindKit.Identifier< Coder.UserDefaultsEncoded, Kind >) throws -> IUserDefaultsValue {
        return try Coder.encode(value.raw)
    }
    
}

extension Identifier : IUserDefaultsDecoderAlias where Raw : IUserDefaultsDecoderAlias {
    
    public typealias UserDefaultsDecoder = UserDefaults.Coder.Identifier< Raw.UserDefaultsDecoder, Kind >
    
}

extension Identifier : IUserDefaultsEncoderAlias where Raw : IUserDefaultsEncoderAlias {
    
    public typealias UserDefaultsEncoder = UserDefaults.Coder.Identifier< Raw.UserDefaultsEncoder, Kind >
    
}
