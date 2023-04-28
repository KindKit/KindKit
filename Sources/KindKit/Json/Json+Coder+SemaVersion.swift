//
//  KindKit
//

import Foundation

public extension Json.Coder {

    struct SemaVersion : IJsonValueDecoder {
        
        public typealias JsonDecoded = KindKit.SemaVersion
        typealias InternalCoder = Json.Coder.String
        
        public static func decode(_ value: IJsonValue, path: Json.Path) throws -> JsonDecoded {
            let value = try InternalCoder.decode(value, path: path)
            guard let value = JsonDecoded(value) else {
                throw Json.Error.Coding.cast(path)
            }
            return value
        }
        
    }
    
}

extension SemaVersion : IJsonDecoderAlias {
    
    public typealias JsonDecoder = Json.Coder.SemaVersion
    
}
