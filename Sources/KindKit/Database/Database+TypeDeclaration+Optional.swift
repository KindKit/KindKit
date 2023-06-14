//
//  KindKit
//

import Foundation

public extension Database.TypeDeclaration {
    
    struct Optional< Wrapped : IDatabaseTypeDeclaration > : IDatabaseTypeDeclaration {
        
        public static var rawTypeDeclaration: String {
            return Wrapped.rawTypeDeclaration
        }
        
        public static var typeDeclaration: String {
            return Wrapped.rawTypeDeclaration
        }
        
    }
    
}

extension Optional : IDatabaseTypeAlias where Wrapped : IDatabaseTypeAlias {
    
    public typealias DatabaseTypeDeclaration = Database.TypeDeclaration.Optional< Wrapped.DatabaseTypeDeclaration >
    
}
