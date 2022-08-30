//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database.TypeDeclaration {
    
    struct Blob : IDatabaseTypeDeclaration {
        
        public static var rawTypeDeclaration: String {
            return "BLOB"
        }
        
        public static var typeDeclaration: String {
            return "BLOB NOT NULL"
        }
        
    }
    
}
