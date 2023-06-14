//
//  KindKit
//

import Foundation

public extension Database.ValueCoder {
    
    struct Real< Value : BinaryFloatingPoint > : IDatabaseValueCoder {
        
        public typealias DatabaseCoded = Value
        
        public static func decode(_ value: Database.Value) throws -> DatabaseCoded {
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
        
        public static func encode(_ value: DatabaseCoded) throws -> Database.Value {
            return .real(Double(value))
        }
        
    }
    
}

extension IDatabaseValueAlias where Self : BinaryFloatingPoint {
    
    public typealias DatabaseValueCoder = Database.ValueCoder.Real< Self >
    
}

extension Float : IDatabaseValueAlias {}
extension Double : IDatabaseValueAlias {}
