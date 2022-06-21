//
//  KindKitJson
//

import Foundation
import KindKitCore

public struct ModelJsonDecoder< DecoderType : IJsonModelDecoder > : IJsonValueDecoder {
    
    public static func decode(_ value: IJsonValue) throws -> DecoderType.ModelType {
        return try DecoderType.decode(Json(root: value))
    }
    
}

public struct ModelJsonEncoder< EncoderType : IJsonModelEncoder > : IJsonValueEncoder {
    
    public static func encode(_ value: EncoderType.ModelType) throws -> IJsonValue {
        let json = Json()
        try EncoderType.encode(value, json: json)
        if let root = json.root {
            return root
        }
        throw JsonError.cast
    }
    
}
