//
//  KindKit
//

import Foundation

public extension TypeDeclaration {
    
    struct Real : ITypeDeclaration {
        
        public static var rawTypeDeclaration: String {
            return "REAL"
        }
        
        public static var typeDeclaration: String {
            return "REAL NOT NULL"
        }
        
    }
    
}

extension ITypeAlias where Self : BinaryFloatingPoint {
    
    public typealias SQLiteTypeDeclaration = TypeDeclaration.Real
    
}

extension Float : ITypeAlias {}
extension Double : ITypeAlias {}
