//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database.ValueDecoder {
    
    struct Optional< Wrapped : IDatabaseValueDecoder > : IDatabaseValueDecoder {
        
        public static func decode(_ value: Database.Value) throws -> Wrapped.Value? {
            return try? Wrapped.decode(value)
        }
        
    }
    
}

extension Optional : IDatabaseValueDecoderAlias where Wrapped : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.Optional< Wrapped.DatabaseValueDecoder >
    
}
