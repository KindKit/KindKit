//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database.ValueDecoder {
    
    struct Blob : IDatabaseValueDecoder {
        
        public static func decode(_ value: Database.Value) throws -> Data {
            switch value {
            case .null, .integer, .real:
                throw Database.Error.decode
            case .text(let value):
                guard let data = value.data(using: .utf8) else {
                    throw Database.Error.decode
                }
                return data
            case .blob(let value):
                return value
            }
        }
        
    }
    
}

extension Data : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.Blob
    
}
