//
//  KindKit
//

import Foundation

public extension UserDefaults.Coder {
    
    struct Json< JsonModelCoder > {
    }
    
}

extension UserDefaults.Coder.Json : IUserDefaultsValueDecoder where JsonModelCoder : IJsonModelDecoder {
    
    public static func decode(_ value: IUserDefaultsValue) throws -> JsonModelCoder.JsonModelDecoded {
        guard let string = try? UserDefaults.Coder.String.decode(value) else {
            throw UserDefaults.Error.cast
        }
        guard let json = Json(string: string) else {
            throw UserDefaults.Error.cast
        }
        do {
            return try json.decode(JsonModelCoder.self)
        } catch {
            throw UserDefaults.Error.cast
        }
    }

}

extension UserDefaults.Coder.Json : IUserDefaultsValueEncoder where JsonModelCoder : IJsonModelEncoder {
    
    public static func encode(_ value: JsonModelCoder.JsonModelEncoded) throws -> IUserDefaultsValue {
        let json = Json()
        do {
            try json.encode(JsonModelCoder.self, value: value)
        } catch {
            throw UserDefaults.Error.cast
        }
        guard let string = try json.saveAsString() else {
            throw UserDefaults.Error.cast
        }
        return try UserDefaults.Coder.String.encode(string)
    }
    
}
