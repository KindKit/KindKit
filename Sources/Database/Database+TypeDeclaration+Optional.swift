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
