//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public extension Database.TypeDeclaration {
    
    struct Text : IDatabaseTypeDeclaration {
        
        public static var rawTypeDeclaration: String {
            return "TEXT"
        }
        
        public static var typeDeclaration: String {
            return "TEXT NOT NULL"
        }
        
    }
    
}
