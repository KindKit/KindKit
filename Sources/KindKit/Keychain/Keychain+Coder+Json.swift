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
        guard let json = Json(data: value) else {
            throw Keychain.Error.cast
        }
        do {
            return try json.decode(JsonModelCoder.self)
        } catch {
            throw Keychain.Error.cast
        }
    }

}

extension Keychain.Coder.Json : IKeychainValueEncoder where JsonModelCoder : IJsonModelEncoder {
    
    public static func encode(_ value: JsonModelCoder.JsonModelEncoded) throws -> Data {
        do {
            let json = Json()
            try json.encode(JsonModelCoder.self, value: value)
            return try json.saveAsData()
        } catch {
            throw UserDefaults.Error.cast
        }
    }
    
}
