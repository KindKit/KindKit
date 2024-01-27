//
//  KindKit
//

import Foundation

public extension ValueCoder {
    
    struct Real< Value : BinaryFloatingPoint > : IValueCoder {
        
        public static func decode(_ value: KindSQLite.Value) throws -> Value {
            switch value {
            case .null:
                throw Error.decode
            case .integer(let value):
                return .init(value)
            case .real(let value):
                return .init(value)
            case .text(let value):
                guard let number = NSNumber.kk_number(from: value) else {
                    throw Error.decode
                }
                return .init(number.doubleValue)
            case .blob:
                throw Error.decode
            }
        }
        
        public static func encode(_ value: Value) throws -> KindSQLite.Value {
            return .real(Double(value))
        }
        
    }
    
}

extension IValueAlias where Self : BinaryFloatingPoint {
    
    public typealias SQLiteValueCoder = ValueCoder.Real< Self >
    
}

extension Float : IValueAlias {}
extension Double : IValueAlias {}
