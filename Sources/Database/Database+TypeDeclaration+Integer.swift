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
