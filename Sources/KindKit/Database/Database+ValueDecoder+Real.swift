//
//  KindKit
//

import Foundation

public extension Database.ValueDecoder {
    
    struct Real< Value : BinaryFloatingPoint > : IDatabaseValueDecoder {
        
        public static func decode(_ value: Database.Value) throws -> Value {
            switch value {
            case .null:
                throw Database.Error.decode
            case .integer(let value):
                return .init(value)
            case .real(let value):
                return .init(value)
            case .text(let value):
                guard let number = NSNumber.kk_number(from: value) else {
                    throw Database.Error.decode
                }
                return .init(number.doubleValue)
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
