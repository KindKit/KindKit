//
//  KindKit
//

import Foundation

public extension Json.Coder {
    
    struct Model< Coder > {
    }
    
}

extension Json.Coder.Model : IJsonValueDecoder where Coder : IJsonModelDecoder {
    
    public typealias JsonDecoded = Coder.JsonModelDecoded
    
    public static func decode(_ value: IJsonValue, path: Json.Path) throws -> JsonDecoded {
        return try Coder.decode(Json(path: path, root: value))
    }
    
}

extension Json.Coder.Model : IJsonValueEncoder where Coder : IJsonModelEncoder {
    
    public typealias JsonEncoded = Coder.JsonModelEncoded
    
    public static func encode(_ value: JsonEncoded, path: Json.Path) throws -> IJsonValue {
        let json = Json(path: path)
        try Coder.encode(value, json: json)
        guard let root = json.root else {
            throw Json.Error.Coding.cast(path)
        }
        return root
    }
    
}
