//
//  KindKitJson
//

import Foundation
import KindKitCore

public struct ModelJsonDecoder< Model : IJsonModelDecoder > : IJsonValueDecoder {
    
    public static func decode(_ value: IJsonValue) throws -> Model.Value {
        return try Model.decode(Json(root: value))
    }
    
}

public struct ModelJsonEncoder< Model : IJsonModelEncoder > : IJsonValueEncoder {
    
    public static func encode(_ value: Model.Value) throws -> IJsonValue {
        let json = Json()
        try Model.encode(value, json: json)
        if let root = json.root {
            return root
        }
        throw JsonError.cast
    }
    
}
