//
//  KindKit
//

import KindJSON

public extension ValueCoder {
    
    struct Json< Coder : KindJSON.IModelCoder > : IValueCoder where Coder.JsonModelDecoded == Coder.JsonModelEncoded {
        
        public typealias SQLiteCoded = Coder.JsonModelDecoded
        
        public static func decode(_ value: Value) throws -> SQLiteCoded {
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
        
        public static func encode(_ value: SQLiteCoded) throws -> Value {
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
