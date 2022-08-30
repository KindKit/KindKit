//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database.ValueDecoder {
    
    struct Real< Value : BinaryFloatingPoint > : IDatabaseValueDecoder {
        
        public static func decode(_ value: Database.Value) throws -> Value {
            switch value {
            case .null:
                throw Database.Error.decode
            case .integer(let value):
                return Value(value)
            case .real(let value):
                return Value(value)
            case .text(let value):
                guard let number = NSNumber.number(from: value) else {
                    throw Database.Error.decode
                }
                return Value(number.doubleValue)
            case .blob:
                throw Database.Error.decode
            }
        }
        
    }
    
}

extension Float : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.Real< Self >
    
}

extension Double : IDatabaseValueDecoderAlias {
    
    public typealias DatabaseValueDecoder = Database.ValueDecoder.Real< Self >
    
}
