//
//  KindKit
//

import Foundation
import KindJSON

public extension ValueCoder {
    
    struct Json< Coder : KindJSON.IModelCoder > : IValueCoder where Coder.JsonModelDecoded == Coder.JsonModelEncoded {
        
        public static func decode(_ value: KindSQLite.Value) throws -> Coder.JsonModelDecoded {
            let data = try ValueCoder.Blob.decode(value)
            do {
                return try KindJSON.Document.parse(
                    data: data,
                    decode: { try $0.decode(Coder.self) }
                )
            } catch {
                throw Error.decode
            }
        }
        
        public static func encode(_ value: Coder.JsonModelDecoded) throws -> KindSQLite.Value {
            do {
                let data: Data = try KindJSON.Document.build({
                    try $0.encode(Coder.self, value: value)
                })
                return .blob(data)
            } catch {
                throw Error.decode
            }
        }
        
    }
    
}

extension IValueAlias where Self : KindJSON.IModelCoder, JsonModelDecoded == JsonModelEncoded {
    
    public typealias SQLiteValueCoder = ValueCoder.Json< Self >
    
}
