//
//  KindKit
//

import Foundation

public extension Database.TypeDeclaration {
    
    struct Real : IDatabaseTypeDeclaration {
        
        public static var rawTypeDeclaration: String {
            return "REAL"
        }
        
        public static var typeDeclaration: String {
            return "REAL NOT NULL"
        }
        
    }
    
}
