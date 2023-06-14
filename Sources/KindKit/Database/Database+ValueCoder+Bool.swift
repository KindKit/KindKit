//
//  KindKit
//

import Foundation

public extension Database.ValueCoder {
    
    struct Bool : IDatabaseValueCoder {
        
        public typealias DatabaseDecoded = Swift.Bool
        
        public static func decode(_ value: Database.Value) throws -> DatabaseDecoded {
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
        
        public static func encode(_ value: DatabaseDecoded) throws -> Database.Value {
            guard value == true else {
                return .integer(0)
            }
            return .integer(1)
        }
        
    }
    
}

extension Bool : IDatabaseTypeAlias {
    
    public typealias DatabaseTypeDeclaration = Database.TypeDeclaration.Integer
    
}

extension Bool : IDatabaseValueAlias {
    
    public typealias DatabaseValueCoder = Database.ValueCoder.Bool
    
}
