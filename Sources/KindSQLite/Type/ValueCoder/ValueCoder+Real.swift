//
//  KindKit
//

import Foundation

public extension ValueCoder {
    
    struct Real< ValueType : BinaryFloatingPoint > : IValueCoder {
        
        public typealias SQLiteCoded = ValueType
        
        public static func decode(_ value: Value) throws -> SQLiteCoded {
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
        
        public static func encode(_ value: SQLiteCoded) throws -> Value {
            return .real(Double(value))
        }
        
    }
    
}

extension IValueAlias where Self : BinaryFloatingPoint {
    
    public typealias SQLiteValueCoder = ValueCoder.Real< Self >
    
}

extension Float : IValueAlias {}
extension Double : IValueAlias {}
