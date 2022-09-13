//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database.ValueDecoder {
    
    struct SemaVersion : IDatabaseValueDecoder {
        
        public typealias Value = KindKitCore.SemaVersion
        
        public static func decode(_ value: Database.Value) throws -> Value {
            let string = try Database.ValueDecoder.Text.decode(value)
            guard let result = Value(string) else {
                throw Database.Error.decode
            }
            return result
        }
        
    }
    
}

extension SemaVersion : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.SemaVersion
    
}
