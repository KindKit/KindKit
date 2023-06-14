//
//  KindKit
//

import Foundation

public extension Database.TypeDeclaration {
    
    struct Integer : IDatabaseTypeDeclaration {
        
        public static var rawTypeDeclaration: String {
            return "INTEGER"
        }
        
        public static var typeDeclaration: String {
            return "INTEGER NOT NULL"
        }
        
    }
    
}

extension IDatabaseTypeAlias where Self : BinaryInteger {
    
    public typealias DatabaseTypeDeclaration = Database.TypeDeclaration.Integer
    
}

extension Int : IDatabaseTypeAlias {}
extension Int8 : IDatabaseTypeAlias {}
extension Int16 : IDatabaseTypeAlias {}
extension Int32 : IDatabaseTypeAlias {}
extension Int64 : IDatabaseTypeAlias {}
extension UInt : IDatabaseTypeAlias {}
extension UInt8 : IDatabaseTypeAlias {}
extension UInt16 : IDatabaseTypeAlias {}
extension UInt32 : IDatabaseTypeAlias {}
extension UInt64 : IDatabaseTypeAlias {}
