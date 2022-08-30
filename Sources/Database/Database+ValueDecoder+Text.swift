//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database.ValueDecoder {
    
    struct Text : IDatabaseValueDecoder {
        
        public static func decode(_ value: Database.Value) throws -> String {
            switch value {
            case .null:
                throw Database.Error.decode
            case .integer(let value):
                return Value(value)
            case .real(let value):
                return Value(value)
            case .text(let value):
                return value
            case .blob(let value):
                guard let string = String(data: value, encoding: .utf8) else {
                    throw Database.Error.decode
                }
                return string
            }
        }
        
    }
    
}

extension String : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.Text
    
}
