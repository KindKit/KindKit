//
//  KindKit
//

import Foundation

public extension Database.ValueDecoder {
    
    struct Json< Decoder : IJsonModelDecoder > : IDatabaseValueDecoder {
        
        public static func decode(_ value: Database.Value) throws -> Decoder.JsonModelDecoded {
            let string = try Database.ValueDecoder.Text.decode(value)
            guard let json = KindKit.Json(string: string) else {
                throw Database.Error.decode
            }
            do {
                return try json.decode(Decoder.self)
            } catch {
                throw Database.Error.decode
            }
        }
        
    }
    
}
