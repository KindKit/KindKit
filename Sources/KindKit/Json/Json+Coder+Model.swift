//
//  KindKit
//

import Foundation

public extension Json.Coder {
    
    struct Model< Coder > {
    }
    
}

extension Json.Coder.Model : IJsonValueDecoder where Coder : IJsonModelDecoder {
    
    public static func decode(_ value: IJsonValue) throws -> Coder.Model {
        return try Coder.decode(Json(root: value))
    }
    
}

extension Json.Coder.Model : IJsonValueEncoder where Coder : IJsonModelEncoder {
    
    public static func encode(_ value: Coder.Model) throws -> IJsonValue {
        let json = Json()
        try Coder.encode(value, json: json)
        if let root = json.root {
            return root
        }
        throw Json.Error.cast
    }
    
}
