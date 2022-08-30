//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database.ValueDecoder {
    
    struct Bool : IDatabaseValueDecoder {
        
        public static func decode(_ value: Database.Value) throws -> Swift.Bool {
            switch value {
            case .null:
                throw Database.Error.decode
            case .integer(let value):
                return value != 0
            case .real(let value):
                return value != 0
            case .text(let value):
                switch value.lowercased() {
                case "1", "true", "yes", "on": return true
                case "0", "false", "no", "off": return false
                default: throw Database.Error.decode
                }
            case .blob:
                throw Database.Error.decode
            }
        }
        
    }
    
}

extension Bool : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.Bool
    
}
