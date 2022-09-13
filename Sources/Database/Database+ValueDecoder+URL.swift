//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database.ValueDecoder {
    
    struct URL : IDatabaseValueDecoder {
        
        public typealias Value = Foundation.URL
        
        public static func decode(_ value: Database.Value) throws -> Value {
            let string = try Database.ValueDecoder.Text.decode(value)
            guard let result = Value(string: string) else {
                throw Database.Error.decode
            }
            return result
        }
        
    }
    
}

extension URL : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.URL
    
}
