//
//  KindKit
//

import Foundation

public extension ValueCoder {
    
    struct Bool : IValueCoder {
        
        public typealias SQLiteDecoded = Swift.Bool
        
        public static func decode(_ value: Value) throws -> SQLiteDecoded {
            switch value {
            case .null:
                throw Error.decode
            case .integer(let value):
                return value != 0
            case .real(let value):
                return value != 0
            case .text(let value):
                switch value.lowercased() {
                case "1", "true", "yes", "on": return true
                case "0", "false", "no", "off": return false
                default: throw Error.decode
                }
            case .blob:
                throw Error.decode
            }
        }
        
        public static func encode(_ value: SQLiteDecoded) throws -> Value {
            guard value == true else {
                return .integer(0)
            }
            return .integer(1)
        }
        
    }
    
}

extension Bool : ITypeAlias {
    
    public typealias SQLiteTypeDeclaration = TypeDeclaration.Integer
    
}

extension Bool : IValueAlias {
    
    public typealias SQLiteValueCoder = ValueCoder.Bool
    
}
