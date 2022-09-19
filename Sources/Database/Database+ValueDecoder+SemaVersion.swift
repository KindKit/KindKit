//
//  KindKit
//

import Foundation

public extension Database.ValueDecoder {
    
    struct SemaVersion : IDatabaseValueDecoder {
        
        public static func decode(_ value: Database.Value) throws -> KindKit.SemaVersion {
            let string = try Database.ValueDecoder.Text.decode(value)
            guard let result = KindKit.SemaVersion(string) else {
                throw Database.Error.decode
            }
            return result
        }
        
    }
    
}

extension SemaVersion : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.SemaVersion
    
}
