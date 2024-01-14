//
//  KindKit
//

import Foundation
import KindJSON

public extension Coder {
    
    struct Json< JsonModelCoder > {
    }
    
}

extension Coder.Json : IValueDecoder where JsonModelCoder : KindJSON.IModelDecoder {
    
    public static func decode(_ value: Data) throws -> JsonModelCoder.JsonModelDecoded {
        do {
            return try KindJSON.Document.parse(
                data: value,
                decode: { try $0.decode(JsonModelCoder.self) }
            )
        } catch {
            throw Error.cast
        }
    }

}

extension Coder.Json : IValueEncoder where JsonModelCoder : KindJSON.IModelEncoder {
    
    public static func encode(_ value: JsonModelCoder.JsonModelEncoded) throws -> Data {
        do {
            return try KindJSON.Document.build({
                try $0.encode(JsonModelCoder.self, value: value)
            })
        } catch {
            throw Error.cast
        }
    }
    
}
