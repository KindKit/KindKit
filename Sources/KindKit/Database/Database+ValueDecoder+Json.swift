//
//  KindKit
//

import Foundation

public extension Database.ValueDecoder {
    
    struct Json< Decoder : IJsonModelDecoder > : IDatabaseValueDecoder {
        
        public static func decode(_ value: Database.Value) throws -> Decoder.JsonModelDecoded {
            let string = try Database.ValueDecoder.Text.decode(value)
            do {
                return try KindKit.Json.parse(
                    string: string,
                    decode: { try $0.decode(Decoder.self) }
                )
            } catch {
                throw Database.Error.decode
            }
        }
        
    }
    
}
