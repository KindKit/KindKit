//
//  KindKit
//

import Foundation

public extension TypeDeclaration {
    
    struct Integer : ITypeDeclaration {
        
        public static var rawTypeDeclaration: String {
            return "INTEGER"
        }
        
        public static var typeDeclaration: String {
            return "INTEGER NOT NULL"
        }
        
    }
    
}

extension ITypeAlias where Self : BinaryInteger {
    
    public typealias SQLiteTypeDeclaration = TypeDeclaration.Integer
    
}

extension Int : ITypeAlias {}
extension Int8 : ITypeAlias {}
extension Int16 : ITypeAlias {}
extension Int32 : ITypeAlias {}
extension Int64 : ITypeAlias {}
extension UInt : ITypeAlias {}
extension UInt8 : ITypeAlias {}
extension UInt16 : ITypeAlias {}
extension UInt32 : ITypeAlias {}
extension UInt64 : ITypeAlias {}
