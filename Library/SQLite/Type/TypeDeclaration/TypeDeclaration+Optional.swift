//
//  KindKit
//

import Foundation

public extension TypeDeclaration {
    
    struct Optional< Wrapped : ITypeDeclaration > : ITypeDeclaration {
        
        public static var rawTypeDeclaration: String {
            return Wrapped.rawTypeDeclaration
        }
        
        public static var typeDeclaration: String {
            return Wrapped.rawTypeDeclaration
        }
        
    }
    
}

extension Optional : ITypeAlias where Wrapped : ITypeAlias {
    
    public typealias SQLiteTypeDeclaration = TypeDeclaration.Optional< Wrapped.SQLiteTypeDeclaration >
    
}
