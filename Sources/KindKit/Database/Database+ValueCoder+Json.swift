//
//  KindKit
//

import Foundation

public extension Database.ValueCoder {
    
    struct Json< Coder : IJsonModelCoder > : IDatabaseValueCoder where Coder.JsonModelDecoded == Coder.JsonModelEncoded {
        
        public typealias DatabaseCoded = Coder.JsonModelDecoded
        
        public static func decode(_ value: Database.Value) throws -> DatabaseCoded {
            let data = try Database.ValueCoder.Blob.decode(value)
            do {
                return try KindKit.Json.parse(
                    data: data,
                    decode: { try $0.decode(Coder.self) }
                )
            } catch {
                throw Database.Error.decode
            }
        }
        
        public static func encode(_ value: DatabaseCoded) throws -> Database.Value {
            do {
                let data: Data = try KindKit.Json.build({
                    try $0.encode(Coder.self, value: value)
                })
                return .blob(data)
            } catch {
                throw Database.Error.decode
            }
        }
        
    }
    
}

extension IDatabaseValueAlias where Self : IJsonModelCoder, JsonModelDecoded == JsonModelEncoded {
    
    public typealias DatabaseValueCoder = Database.ValueCoder.Json< Self >
    
}
