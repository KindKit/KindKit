//
//  KindKit
//

import Foundation

public extension Keychain.Coder {
    
    struct Json< JsonModelCoder > {
    }
    
}

extension Keychain.Coder.Json : IKeychainValueDecoder where JsonModelCoder : IJsonModelDecoder {
    
    public static func decode(_ value: Data) throws -> JsonModelCoder.JsonModelDecoded {
        do {
            return try KindKit.Json.parse(
                data: value,
                decode: { try $0.decode(JsonModelCoder.self) }
            )
        } catch {
            throw Keychain.Error.cast
        }
    }

}

extension Keychain.Coder.Json : IKeychainValueEncoder where JsonModelCoder : IJsonModelEncoder {
    
    public static func encode(_ value: JsonModelCoder.JsonModelEncoded) throws -> Data {
        do {
            return try Json.build({
                try $0.encode(JsonModelCoder.self, value: value)
            })
        } catch {
            throw UserDefaults.Error.cast
        }
    }
    
}
