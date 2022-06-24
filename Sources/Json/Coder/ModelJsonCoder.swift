//
//  KindKitJson
//

import Foundation
import KindKitCore

public struct ModelJsonDecoder< Decoder : IJsonModelDecoder > : IJsonValueDecoder {
    
    public static func decode(_ value: IJsonValue) throws -> Decoder.Model {
        return try Decoder.decode(Json(root: value))
    }
    
}

public struct ModelJsonEncoder< Encoder : IJsonModelEncoder > : IJsonValueEncoder {
    
    public static func encode(_ value: Encoder.Model) throws -> IJsonValue {
        let json = Json()
        try Encoder.encode(value, json: json)
        if let root = json.root {
            return root
        }
        throw JsonError.cast
    }
    
}
